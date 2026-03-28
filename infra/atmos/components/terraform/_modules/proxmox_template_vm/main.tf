resource tls_private_key nixos_admin_ssh_key {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  nixos_admin_private_ssh_key = tls_private_key.nixos_admin_ssh_key.private_key_openssh
  nixos_admin_public_ssh_key  = tls_private_key.nixos_admin_ssh_key.public_key_openssh

  default_settings = {
    autostart              = true
    startup_shutdown_order = -1
    cloud_init             = {
      user      = "opentofu"
      ip_config = "ip=dhcp"
    }
  }

  settings = {
    autostart              = coalesce(var.settings.autostart, true)
    startup_shutdown_order = coalesce(var.settings.startup_shutdown_order, -1)
    cloud_init             = {
      user      = coalesce(var.settings.cloud_init.user, "opentofu")
      ssh_keys  = join("\n", concat(var.settings.cloud_init.ssh_keys, [local.nixos_admin_public_ssh_key]))
      ip_config = coalesce(var.settings.cloud_init.ip_config, "ip=dhcp")
    }
  }
}

resource proxmox_vm_qemu vm {
  name        = var.general.name
  tags        = var.general.tags
  target_node = var.general.proxmox_host
  clone       = var.general.proxmox_template
  full_clone  = true

  # VM Settings
  start_at_node_boot = local.settings.autostart
  agent              = 1
  skip_ipv6          = true
  os_type            = "cloud-init"
  scsihw             = "virtio-scsi-pci"

  cpu {
    cores = var.hardware.core_count
  }

  memory = var.hardware.memory_capacity

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.hardware.storage.location
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          format     = "raw"
          size       = var.hardware.storage.capacity
          storage    = var.hardware.storage.location
          emulatessd = true
          discard    = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.hardware.networking.bridge
    tag    = var.hardware.networking.vlan_tag
  }

  startup_shutdown {
    order            = local.settings.startup_shutdown_order
    shutdown_timeout = -1
    startup_delay    = -1
  }

  # Cloud Init settings
  ciuser    = local.settings.cloud_init.user
  sshkeys   = local.settings.cloud_init.ssh_keys
  ciupgrade = false
  ipconfig0 = local.settings.cloud_init.ip_config
}

module nixos_deployment {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = "${var.nixos.flake.path}#nixosConfigurations.${var.nixos.flake.configuration_name}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.nixos.flake.path}#nixosConfigurations.${var.nixos.flake.configuration_name}.config.system.build.diskoScript"
  target_host            = proxmox_vm_qemu.vm.default_ipv4_address
  target_user            = local.settings.cloud_init.user
  install_ssh_key        = local.nixos_admin_private_ssh_key
  deployment_ssh_key     = local.nixos_admin_private_ssh_key
  special_args = {
   terraform = {
     hostname = proxmox_vm_qemu.vm.name
     username = var.nixos.user.name
     ssh_keys = var.nixos.user.ssh_keys
     options  = var.nixos.options
   }
  }
}


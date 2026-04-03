resource tls_private_key nixos_admin_ssh_key {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  nixos_admin_private_ssh_key = tls_private_key.nixos_admin_ssh_key.private_key_openssh
  nixos_admin_public_ssh_key  = tls_private_key.nixos_admin_ssh_key.public_key_openssh
  cloud_init_ssh_keys         = join("\n", concat(var.config.settings.cloud_init.ssh_keys, [local.nixos_admin_public_ssh_key]))
}

resource proxmox_vm_qemu vm {
  name        = var.config.general.name
  tags        = join("\n", var.config.general.tags)
  target_node = var.config.general.proxmox_host
  clone       = var.config.general.proxmox_template
  full_clone  = true

  # VM Settings
  start_at_node_boot = var.config.settings.autostart
  agent              = 1
  skip_ipv6          = true
  os_type            = "cloud-init"
  scsihw             = "virtio-scsi-pci"

  cpu {
    cores = var.config.hardware.core_count
  }

  memory = var.config.hardware.memory_capacity

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.config.hardware.storage.location
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          format     = "raw"
          size       = var.config.hardware.storage.capacity
          storage    = var.config.hardware.storage.location
          emulatessd = true
          discard    = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.config.hardware.networking.bridge
    tag    = var.config.hardware.networking.vlan_tag
  }

  startup_shutdown {
    order            = var.config.settings.startup_shutdown_order
    shutdown_timeout = -1
    startup_delay    = -1
  }

  # Cloud Init settings
  ciuser    = var.config.settings.cloud_init.user
  sshkeys   = local.cloud_init_ssh_keys
  ciupgrade = false
  ipconfig0 = var.config.settings.cloud_init.ip_config
}

module nixos_deployment {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = "${var.config.nixos.flake.path}#nixosConfigurations.${var.config.nixos.flake.configuration_name}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.config.nixos.flake.path}#nixosConfigurations.${var.config.nixos.flake.configuration_name}.config.system.build.diskoScript"
  target_host            = proxmox_vm_qemu.vm.default_ipv4_address
  target_user            = var.config.settings.cloud_init.user
  install_ssh_key        = local.nixos_admin_private_ssh_key
  deployment_ssh_key     = local.nixos_admin_private_ssh_key
  special_args = {
   terraform = {
     hostname = proxmox_vm_qemu.vm.name
     username = var.config.nixos.user.name
     ssh_keys = var.config.nixos.user.ssh_keys
     options  = var.config.nixos.options
   }
  }
}


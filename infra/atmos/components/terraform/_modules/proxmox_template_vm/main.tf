locals {
  use_nixos           = var.config.general.proxmox_template == "nixos-cloudinit-template"
  nixos_admin_ssh_key = try(tls_private_key.nixos_admin_ssh_key[0], null)
  cloud_init                  = {
    username = local.use_nixos ? "opentofu" : var.config.settings.user.name
    ssh_keys = local.use_nixos ? local.nixos_admin_ssh_key.public_key_openssh : join("\n", var.config.settings.user.ssh_keys)
  }
}

resource tls_private_key nixos_admin_ssh_key {
  count = local.use_nixos ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource proxmox_vm_qemu vm {
  name        = var.config.general.name
  tags        = join(",", var.config.general.tags)
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
  ciuser    = local.cloud_init.username
  sshkeys   = local.cloud_init.ssh_keys
  ciupgrade = false
  ipconfig0 = "ip=dhcp"
}

module nixos_deployment {
  count = local.use_nixos ? 1 : 0

  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = "${var.config.nixos.flake.path}#nixosConfigurations.${var.config.nixos.flake.configuration_name}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.config.nixos.flake.path}#nixosConfigurations.${var.config.nixos.flake.configuration_name}.config.system.build.diskoScript"
  target_host            = proxmox_vm_qemu.vm.default_ipv4_address
  target_user            = local.cloud_init.username
  install_ssh_key        = local.nixos_admin_ssh_key.private_key_openssh
  deployment_ssh_key     = local.nixos_admin_ssh_key.private_key_openssh
  special_args = {
   terraform = {
     hostname = proxmox_vm_qemu.vm.name
     username = var.config.settings.user.name
     ssh_keys = var.config.settings.user.ssh_keys
     options  = var.config.nixos.options
   }
  }
}


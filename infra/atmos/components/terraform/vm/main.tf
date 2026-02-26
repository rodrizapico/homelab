resource tls_private_key ssh_key {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource proxmox_vm_qemu vm {
  name        = "${var.namespace}-${var.stage}-vm-${var.vm_name}"
  tags        = "${var.namespace},${var.stage}"
  target_node = var.proxmox_host
  clone       = var.template_name
  full_clone  = true

  # VM Settings
  agent     = 1
  skip_ipv6 = true
  os_type   = "cloud-init"
  scsihw    = "virtio-scsi-pci"

  cpu {
    cores = var.core_count
  }

  memory = var.memory_capacity

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          format     = "raw"
          size       = var.disk_capacity
          storage    = var.disk_storage_location
          emulatessd = true
          discard    = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan_tag
  }

  startup_shutdown {
    order            = var.startup_shutdown_order
    shutdown_timeout = -1
    startup_delay    = -1
  }

  # Cloud Init settings
  ciuser    = var.cloud_init_user
  sshkeys   = tls_private_key.ssh_key.public_key_openssh
  ciupgrade = false
  ipconfig0 = var.cloud_init_ip_config
}

module "deploy" {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr      = "${var.nixos_flake.path}#nixosConfigurations.${var.nixos_flake.configuration_name}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.nixos_flake.path}#nixosConfigurations.${var.nixos_flake.configuration_name}.config.system.build.diskoScript"
  target_host            = proxmox_vm_qemu.vm.default_ipv4_address
  target_user            = var.cloud_init_user
  install_ssh_key        = tls_private_key.ssh_key.private_key_openssh
  deployment_ssh_key     = tls_private_key.ssh_key.private_key_openssh
  special_args = {
   terraform = {
     hostname = proxmox_vm_qemu.vm.name
     username = var.nixos_user.name
     ssh_keys = var.nixos_user.ssh_keys
   }
  }
}


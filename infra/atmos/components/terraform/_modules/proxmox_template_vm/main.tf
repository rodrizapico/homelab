locals {
  use_nixos           = var.config.os_preset != "none"
  nixos_admin_ssh_key = try(tls_private_key.nixos_admin_ssh_key[0], null)
  cloud_init = {
    username = local.use_nixos ? "opentofu" : var.config.user.name
    ssh_keys = local.use_nixos ? local.nixos_admin_ssh_key.public_key_openssh : join("\n", var.config.user.ssh_keys)
  }

  proxmox = {
    allowed_nodes = coalesce(try(var.config.advanced.proxmox.allowed_nodes, null), var.proxmox.default_allowed_nodes)
    storage       = coalesce(try(var.config.advanced.proxmox.vm_storage, null), var.proxmox.default_vm_storage)
    template      = coalesce(try(var.config.advanced.proxmox.vm_template, null), var.proxmox.default_vm_template)
    bridge        = coalesce(try(var.config.advanced.proxmox.vm_bridge, null), var.proxmox.default_vm_bridge)
    vlan_tag      = try(var.config.advanced.proxmox.vm_vlan_tag, null)
  }

  hardware_presets = {
    sm = {
      core_count       = 1
      memory_capacity  = 1024
      storage_capacity = "32G"
    }

    md = {
      core_count       = 1
      memory_capacity  = 2048
      storage_capacity = "32G"
    }

    lg = {
      core_count       = 2
      memory_capacity  = 4096
      storage_capacity = "32G"
    }

    xl = {
      core_count       = 2
      memory_capacity  = 8192
      storage_capacity = "100G"
    }

    custom = {
      core_count       = try(var.config.advanced.hardware.core_count, null)
      memory_capacity  = try(var.config.advanced.hardware.memory_capacity, null)
      storage_capacity = try(var.config.advanced.hardware.storage_capacity, null)
    }
  }

  hardware = {
    core_count       = local.hardware_presets[var.config.hardware_preset].core_count
    memory_capacity  = local.hardware_presets[var.config.hardware_preset].memory_capacity
    storage_capacity = local.hardware_presets[var.config.hardware_preset].storage_capacity
  }
}

resource "tls_private_key" "nixos_admin_ssh_key" {
  count = local.use_nixos ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_vm_qemu" "vm" {
  name         = var.config.name
  tags         = join(",", var.config.tags)
  target_nodes = local.proxmox.allowed_nodes
  clone        = local.proxmox.template
  full_clone   = true

  # VM Settings
  start_at_node_boot = coalesce(try(var.config.advanced.settings.autostart, null), true)
  agent              = 1
  skip_ipv6          = true
  os_type            = "cloud-init"
  scsihw             = "virtio-scsi-pci"

  cpu {
    cores = local.hardware.core_count
  }

  memory = local.hardware.memory_capacity

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = local.proxmox.storage
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          format     = "raw"
          size       = local.hardware.storage_capacity
          storage    = local.proxmox.storage
          emulatessd = true
          discard    = true
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = local.proxmox.bridge
    tag    = local.proxmox.vlan_tag
  }

  startup_shutdown {
    order            = coalesce(try(var.config.advanced.settings.startup_shutdown_order, null), -1)
    shutdown_timeout = -1
    startup_delay    = -1
  }

  # Cloud Init settings
  ciuser    = local.cloud_init.username
  sshkeys   = local.cloud_init.ssh_keys
  ciupgrade = false
  ipconfig0 = "ip=dhcp"
}

module "nixos_deployment" {
  count  = local.use_nixos ? 1 : 0
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "${var.nixos_flake_path}#nixosConfigurations.${var.config.os_preset}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.nixos_flake_path}#nixosConfigurations.${var.config.os_preset}.config.system.build.diskoScript"
  target_host            = proxmox_vm_qemu.vm.default_ipv4_address
  target_user            = local.cloud_init.username
  install_ssh_key        = local.nixos_admin_ssh_key.private_key_openssh
  deployment_ssh_key     = local.nixos_admin_ssh_key.private_key_openssh
  special_args = {
    terraform = {
      hostname = proxmox_vm_qemu.vm.name
      username = var.config.user.name
      ssh_keys = var.config.user.ssh_keys
      options  = var.config.os_preset_options
    }
  }
}


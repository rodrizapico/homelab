locals {
  use_nixos           = var.config.os_preset != "none"
  nixos_admin_ssh_key = try(tls_private_key.nixos_admin_ssh_key[0], null)
  cloud_init = {
    username = local.use_nixos ? "opentofu" : var.config.user.name
    ssh_keys = local.use_nixos ? [local.nixos_admin_ssh_key.public_key_openssh] : var.config.user.ssh_keys
  }

  proxmox = {
    allowed_nodes = coalesce(try(var.config.advanced.proxmox.allowed_nodes, null), var.proxmox.default_allowed_nodes)
    storage       = coalesce(try(var.config.advanced.proxmox.vm_storage, null), var.proxmox.default_vm_storage)
    template_id   = coalesce(try(var.config.advanced.proxmox.vm_template_id, null), var.proxmox.default_vm_template_id)
    bridge        = coalesce(try(var.config.advanced.proxmox.vm_bridge, null), var.proxmox.default_vm_bridge)
    vlan_tag      = try(var.config.advanced.proxmox.vm_vlan_tag, null)
  }

  hardware_presets = {
    sm = {
      core_count       = 1
      memory_capacity  = 1024
      storage_capacity = "32"
    }

    md = {
      core_count       = 1
      memory_capacity  = 2048
      storage_capacity = "32"
    }

    lg = {
      core_count       = 2
      memory_capacity  = 4096
      storage_capacity = "32"
    }

    xl = {
      core_count       = 2
      memory_capacity  = 8192
      storage_capacity = "100"
    }

    xxl = {
      core_count       = 4
      memory_capacity  = 16384
      storage_capacity = "250"
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

resource "random_shuffle" "vm_node" {
  input        = local.proxmox.allowed_nodes
  result_count = 1
}

resource "tls_private_key" "nixos_admin_ssh_key" {
  count = local.use_nixos ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.config.name
  description = "Managed by Atmos/OpenTofu"
  tags        = var.config.tags
  node_name   = random_shuffle.vm_node.result[0]

  clone {
    vm_id = local.proxmox.template_id
  }

  agent {
    enabled = true
    wait_for_ip {
      ipv4 = true
      ipv6 = false
    }
  }

  # VM Settings
  machine       = "q35"
  bios          = "seabios"
  on_boot       = coalesce(try(var.config.advanced.settings.autostart, null), true)
  scsi_hardware = "virtio-scsi-pci"

  operating_system {
    type = "l26"
  }

  cpu {
    cores = local.hardware.core_count
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.hardware.memory_capacity
    floating  = local.hardware.memory_capacity
  }

  disk {
    datastore_id = local.proxmox.storage
    file_format  = "raw"
    interface    = "scsi0"
    size         = local.hardware.storage_capacity
    discard      = "on"
    ssd          = true
  }

  network_device {
    model   = "virtio"
    bridge  = local.proxmox.bridge
    vlan_id = local.proxmox.vlan_tag
  }

  startup {
    order = coalesce(try(var.config.advanced.settings.startup_shutdown_order, null), 1000)
  }

  # Cloud Init settings
  initialization {
    datastore_id = local.proxmox.storage

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = local.cloud_init.username
      keys     = local.cloud_init.ssh_keys
    }
  }

  lifecycle {
    ignore_changes = [node_name]
  }
}

module "nixos_deployment" {
  count  = local.use_nixos ? 1 : 0
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "${var.nixos_flake_path}#nixosConfigurations.${var.config.os_preset}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.nixos_flake_path}#nixosConfigurations.${var.config.os_preset}.config.system.build.diskoScript"
  target_host            = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
  target_user            = local.cloud_init.username
  install_ssh_key        = local.nixos_admin_ssh_key.private_key_openssh
  deployment_ssh_key     = local.nixos_admin_ssh_key.private_key_openssh
  special_args = {
    terraform = {
      hostname = proxmox_virtual_environment_vm.vm.name
      username = var.config.user.name
      ssh_keys = var.config.user.ssh_keys
      options  = var.config.os_preset_options
    }
  }
}


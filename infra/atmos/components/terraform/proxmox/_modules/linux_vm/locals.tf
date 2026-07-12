locals {
  hardware_presets = {
    sm = {
      core_count       = 1
      memory_capacity  = 1024
      storage_capacity = 32
    }

    md = {
      core_count       = 1
      memory_capacity  = 2048
      storage_capacity = 32
    }

    lg = {
      core_count       = 2
      memory_capacity  = 4096
      storage_capacity = 32
    }

    xl = {
      core_count       = 2
      memory_capacity  = 8192
      storage_capacity = 100
    }

    xxl = {
      core_count       = 4
      memory_capacity  = 16384
      storage_capacity = 250
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

  cloud_init = {
    vendor_data_file_id = try(var.config.advanced.cloud_init.vendor_data_file_id, null)

    username = var.config.user.name
    ssh_keys = var.config.user.ssh_keys
  }

  vm = {
    node          = var.config.node
    clone_id      = try(var.config.clone_id, null)
    disk_image_id = try(var.config.disk_image_id, null)
    template      = try(var.config.advanced.template, false)
    storage       = coalesce(try(var.config.advanced.proxmox.vm_storage, null), var.proxmox.default_vm_storage)
    bridge        = coalesce(try(var.config.advanced.proxmox.vm_bridge, null), var.proxmox.default_vm_bridge)
    vlan_tag      = coalesce(var.config.advanced.proxmox.vm_vlan_tag, var.proxmox.default_vm_vlan_tag)
  }

  settings = {
    autostart              = coalesce(try(var.config.advanced.settings.autostart, null), true)
    startup_shutdown_order = coalesce(try(var.config.advanced.settings.startup_shutdown_order, null), 1000)
  }
}

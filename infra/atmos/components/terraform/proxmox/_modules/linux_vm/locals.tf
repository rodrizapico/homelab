locals {
  instance_types = {
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
      memory_capacity  = try(var.config.advanced.hardware.memory.capacity, null)
      storage_capacity = try(var.config.advanced.hardware.storage.capacity, null)
    }
  }

  hardware = {
    core_count       = local.instance_types[var.config.instance_type].core_count
    bridge           = try(var.config.advanced.hardware.bridge, null)
    vlan_tag         = try(var.config.advanced.hardware.vlan_tag, null)
    memory_capacity  = local.instance_types[var.config.instance_type].memory_capacity
    storage_location = try(var.config.advanced.hardware.storage.location, null)
    storage_capacity = local.instance_types[var.config.instance_type].storage_capacity
  }

  cloud_init = {
    vendor_data_file_id = try(var.config.advanced.cloud_init.vendor_data_file_id, null)

    username = var.config.user.name
    ssh_keys = var.config.user.ssh_keys

    ip_config = {
      ipv4 = {
        address = try(var.config.advanced.ip_config.ipv4.address, "dhcp")
        gateway = try(var.config.advanced.ip_config.ipv4.gateway, null)
      }
    }
  }

  vm = {
    clone_id      = try(var.config.clone_id, null)
    disk_image_id = try(var.config.disk_image_id, null)
    template      = try(var.config.advanced.template, false)
  }

  settings = {
    autostart              = coalesce(try(var.config.advanced.settings.autostart, null), true)
    startup_shutdown_order = coalesce(try(var.config.advanced.settings.startup_shutdown_order, null), 1000)
  }
}

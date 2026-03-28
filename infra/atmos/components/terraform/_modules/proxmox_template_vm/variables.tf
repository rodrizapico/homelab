# This file should be (mostly) synced up with infra/atmos/components/terraform/vm

variable general {
  description = "Base values required to provision a new VM"
  type        = object({
    name             = string
    tags             = string
    proxmox_host     = string
    proxmox_template = string
  })
}

variable hardware {
  description = "Hardware specs for the VM"
  type        = object({
    core_count      = optional(number, 1)
    memory_capacity = optional(number, 1024)
    storage         = object({
      location = string
      capacity = optional(string, "32G")
    })
    networking      = object({
      bridge   = string
      vlan_tag = number
    })
  })
}

variable settings {
  description = "Other VM settings"
  type        = object({
    autostart              = optional(bool)
    startup_shutdown_order = optional(number)
    cloud_init             = optional(object({
      user      = optional(string)
      ssh_keys  = optional(list(string), [])
      ip_config = optional(string)
    }), {})
  })
  default = {}
}

variable nixos {
  description = "NixOS settings"
  type        = object({
    flake = object({
      path               = string
      configuration_name = string
    })
    user = object({
      name     = string
      ssh_keys = list(string)
    })
    options = optional(any)
  })
}

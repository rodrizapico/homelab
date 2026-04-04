# This file should be (mostly) synced up with infra/atmos/components/terraform/vm/variables.tf

variable config {
  description = "A collection of all VM's configuration options"
  type        = object({
    general = object({
      name             = string
      tags             = optional(list(string), [])
      proxmox_host     = string
      proxmox_template = string
    })

    hardware = object({
      core_count      = optional(number, 1)
      memory_capacity = optional(number, 1024)

      storage = object({
        location = string
        capacity = optional(string, "32G")
      })

      networking = object({
        bridge   = string
        vlan_tag = optional(number)
      })
    })
    
    settings = optional(object({
      autostart              = optional(bool, true)
      startup_shutdown_order = optional(number, -1)
      user                   = optional(object({
        name     = optional(string, "opentofu")
        ssh_keys = optional(list(string), [])
      }))
    }), {
      autostart              = true
      startup_shutdown_order = -1
      user                   = {
        name      = "opentofu"
        ssh_keys  = []
      }
    })

    nixos = object({
      flake = object({
        path               = string
        configuration_name = string
      })
      options = optional(any)
    })
  })
}

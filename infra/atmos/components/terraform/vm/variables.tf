# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_template_vm/variables.tf

# Global variables

variable namespace {}

variable stage {}

variable proxmox {
  description = "Proxmox cluster configuration"
  type        = object({
    api_url               = string
    default_allowed_nodes = list(string)
    default_vm_template   = string
    default_vm_storage    = string
    default_vm_bridge     = string
  })
}

# Component specific variables

variable config {
  description = "A collection of all VM's configuration options"
  type        = object({
    name = string

    hardware = object({
      core_count       = optional(number, 1)
      memory_capacity  = optional(number, 1024)
      storage_capacity = optional(string, "32G")
      vlan_tag         = optional(number)
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

    nixos = optional(object({
      flake = optional(object({
        path               = optional(string)
        configuration_name = optional(string)
      }))
      options = optional(any)
    }))

    advanced = optional(object({
      proxmox = optional(object({
        allowed_nodes = optional(list(string))
        vm_template   = optional(string)
        vm_storage    = optional(string)
        vm_bridge     = optional(string)
      }))
    }))
  })
}

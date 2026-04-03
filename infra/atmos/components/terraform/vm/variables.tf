# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_template_vm/variables.tf

# Global variables

variable namespace {}

variable stage {}

# Component specific variables

variable config {
  description = "A collection of all VM's configuration options"
  type        = object({
    name = string

    proxmox = object({
      host     = string
      template = string
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
      cloud_init             = optional(object({
        user      = optional(string, "opentofu")
        ssh_keys  = optional(list(string), [])
        ip_config = optional(string, "ip=dhcp")
      }), {})
    }), {
      autostart              = true
      startup_shutdown_order = -1

      cloud_init = {
        user      = "opentofu"
        ssh_keys  = []
        ip_config = "ip=dhcp"
      }
    })

    nixos = object({
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
  })
}

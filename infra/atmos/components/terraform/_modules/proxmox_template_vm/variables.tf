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

    nixos = optional(object({
      flake = optional(object({
        path               = optional(string)
        configuration_name = optional(string)
      }))
      options = optional(any)
    }))
  })

  validation {
    condition     = contains(["nixos-cloudinit-template", "arch-cloudinit-template"], var.config.general.proxmox_template)
    error_message = "'config.general.proxmox_template' must be 'nixos-cloudinit-template' or 'arch-cloudinit-template'."
  }

  validation {
    condition     = var.config.general.proxmox_template != "nixos-cloudinit-template" || try(var.config.nixos.flake.path != null && var.config.nixos.flake.configuration_name != null, false)
    error_message = "For NixOS installs, 'config.nixos.flake.path' and 'config.nixos.flake.configuration_name' are required."
  }
}

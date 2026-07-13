# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_vm/variables.tf

# Global variables

variable "namespace" {}

variable "stage" {}

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url               = string
    api_token             = string
    default_allowed_nodes = list(string)
    default_iso_storage   = string
    default_vm_storage    = string
    default_vm_bridge     = string
  })
}

# Component specific variables

variable "config" {
  description = "A collection of all VM's configuration options"
  type = object({
    name        = string
    description = optional(string)
    node        = string

    template_id     = string
    hardware_preset = string

    user = object({
      name              = optional(string)
      ssh_keys          = optional(list(string))
      generate_ssh_keys = optional(bool)
    })

    advanced = optional(object({
      proxmox = optional(object({
        vm_storage  = optional(string)
        vm_bridge   = optional(string)
        vm_vlan_tag = optional(number)
      }))

      hardware = optional(object({
        core_count       = optional(number)
        memory_capacity  = optional(number)
        storage_capacity = optional(string)
      }))

      ip_config = optional(object({
        ipv4 = optional(object({
          address = string
          gateway = optional(string)
        }))
      }))

      settings = optional(object({
        autostart              = optional(bool)
        startup_shutdown_order = optional(number)
      }))
    }))
  })
}

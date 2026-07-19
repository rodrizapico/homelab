# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_vm/variables.tf

# Global variables

variable "namespace" {}

variable "stage" {}

# Component specific variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url     = string
    api_token   = string
    node        = string
    vm_storage  = string
    vm_bridge   = string
    vm_vlan_tag = number
  })
}

variable "config" {
  description = "A collection of all VM's configuration options"
  type = object({
    name        = string
    description = optional(string)

    template_id = optional(string)
    image_id    = optional(string)

    hardware_preset = string

    user = optional(object({
      name              = optional(string)
      ssh_keys          = optional(list(string))
      generate_ssh_keys = optional(bool)
    }))

    advanced = optional(object({
      template = optional(bool, false)

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

      cloud_init = optional(object({
        vendor_data_file_id = optional(string)
      }))
    }))
  })
}

# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_vm/variables.tf

# Global variables

variable "namespace" {}

variable "stage" {}

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url   = string
    api_token = string
    ssh_user  = optional(string)

    default_node                          = optional(string)
    default_vm_storage                    = optional(string, "local-lvm")
    default_iso_storage                   = optional(string, "local")
    default_vm_bridge                     = optional(string, "vmbr0")
    default_vm_vlan_tag                   = optional(string)
    default_cloudinit_vendor_data_file_id = optional(string)
  })
}

# Component specific variables

variable "config" {
  description = "A collection of all VM's configuration options"
  type = object({
    name        = string
    description = optional(string)
    node        = optional(string)

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

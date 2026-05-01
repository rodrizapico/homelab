# This file should be (mostly) synced up with infra/atmos/components/terraform/_modules/proxmox_template_vm/variables.tf

# Global variables

variable "namespace" {}

variable "stage" {}

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url               = string
    api_token             = string
    default_allowed_nodes = list(string)
    # Must be a cloud init enabled template
    default_vm_template_id = string
    default_vm_storage     = optional(string, "local-lvm")
    default_vm_bridge      = optional(string, "vmbr0")
  })
}

variable "nixos_flake_path" {
  description = "Path to the NixOS flake that contains configuration presets"
  type        = string
  default     = null
}

# Component specific variables

variable "config" {
  description = "A collection of all VM's configuration options"
  type = object({
    name = string
    # Must be either 'none' or a valid config from the configured flake
    os_preset         = optional(string)
    os_preset_options = optional(any)
    hardware_preset   = optional(string)

    user = optional(object({
      name     = optional(string)
      ssh_keys = optional(list(string))
    }))

    advanced = optional(object({
      proxmox = optional(object({
        allowed_nodes  = optional(list(string))
        vm_template_id = optional(string)
        vm_storage     = optional(string)
        vm_bridge      = optional(string)
        vm_vlan_tag    = optional(number)
      }))

      hardware = optional(object({
        core_count       = optional(number)
        memory_capacity  = optional(number)
        storage_capacity = optional(string)
      }))

      settings = optional(object({
        autostart              = optional(bool)
        startup_shutdown_order = optional(number)
      }))
    }))
  })
}

# This file should be (mostly) synced up with infra/atmos/components/terraform/vm/variables.tf

# Global variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url               = string
    default_allowed_nodes = list(string)
    # Must be a cloud init enabled template
    default_vm_template = string
    default_vm_storage  = string
    default_vm_bridge   = string
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
    tags = optional(list(string), [])
    # Must be either 'none' or a valid config from the configured flake
    os_preset         = optional(string, "none")
    os_preset_options = optional(any)
    hardware_preset   = optional(string, "sm")

    user = optional(object({
      name     = optional(string, "opentofu")
      ssh_keys = optional(list(string), [])
      }), {
      name     = "opentofu"
      ssh_keys = []
    })

    advanced = optional(object({
      proxmox = optional(object({
        allowed_nodes = optional(list(string))
        vm_template   = optional(string)
        vm_storage    = optional(string)
        vm_bridge     = optional(string)
        vm_vlan_tag   = optional(number)
      }))

      hardware = optional(object({
        core_count       = optional(number)
        memory_capacity  = optional(number)
        storage_capacity = optional(string)
      }))

      settings = optional(object({
        autostart              = optional(bool, true)
        startup_shutdown_order = optional(number, -1)
        }), {
        autostart              = true
        startup_shutdown_order = -1
      })
    }))
  })

  validation {
    error_message = "Hardware preset must be one of 'sm', 'md', 'lg', 'xl' or 'custom'."
    condition     = contains(["sm", "md", "lg", "xl", "custom"], var.config.hardware_preset)
  }

  validation {
    error_message = "For the 'custom' hardware preset, the following values under 'advanced.hardware' are required: 'core_count', 'memory_capacity' and 'storage_capacity'."
    condition = (
      !contains(["custom"], var.config.hardware_preset) ||
      try(
        var.config.advanced.hardware.core_count != null &&
        var.config.advanced.hardware.memory_capacity != null &&
        var.config.advanced.hardware.storage_capacity != null,
        false
      )
    )
  }

  validation {
    error_message = "The following values under 'advanced.hardware' can only be set for the 'custom' hardware preset: 'core_count', 'memory_capacity' and 'storage_capacity'."
    condition = (
      contains(["custom"], var.config.hardware_preset) ||
      (
        try(var.config.advanced.hardware.core_count == null, true) &&
        try(var.config.advanced.hardware.memory_capacity == null, true) &&
        try(var.config.advanced.hardware.storage_capacity == null, true)
      )
    )
  }

  validation {
    condition     = var.nixos_flake_path != null || contains(["none"], var.config.os_preset)
    error_message = "When 'nixos_flake_path' is not set, the only allowed OS preset is 'none'."
  }

  validation {
    condition     = try(var.config.advanced.proxmox.vm_template == null, true) || contains(["none"], var.config.os_preset)
    error_message = "When 'advanced.proxmox.vm_template' is set, the only allowed OS preset is 'none'."
  }

  validation {
    condition     = !contains(["sm"], var.config.hardware_preset) || contains(["none"], var.config.os_preset)
    error_message = "When using the 'sm' hardware preset, the only allowed OS preset is 'none'."
  }
}

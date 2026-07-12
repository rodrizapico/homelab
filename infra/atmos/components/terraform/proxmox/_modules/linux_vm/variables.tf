# Global variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    default_vm_storage  = optional(string, "local-lvm")
    default_vm_bridge   = optional(string, "vmbr0")
    default_vm_vlan_tag = optional(string)
  })
}

# Component specific variables

variable "config" {
  description = "A collection of all VM's configuration options"
  type = object({
    name        = string
    tags        = optional(list(string), [])
    description = optional(string, "Managed by Atmos/OpenTofu")

    node            = string
    clone_id        = optional(string, null)
    disk_image_id   = optional(string, null)
    hardware_preset = optional(string, "sm")

    user = optional(object({
      name              = optional(string, "opentofu")
      ssh_keys          = optional(list(string), [])
      generate_ssh_keys = optional(bool, false)
      }), {
      name              = "opentofu"
      ssh_keys          = []
      generate_ssh_keys = false
    })

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
        storage_capacity = optional(number)
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

  validation {
    error_message = "Either 'var.config.clone_id' or 'var.config.disk_image_id' need to be set"
    condition     = var.config.clone_id != null || var.config.disk_image_id != null
  }

  validation {
    error_message = "'var.config.clone_id' and 'var.config.disk_image_id' can't both be set"
    condition     = var.config.clone_id == null || var.config.disk_image_id == null
  }

  validation {
    error_message = "'config.hardware_preset' must be one of 'sm', 'md', 'lg', 'xl' or 'custom'."
    condition     = contains(["sm", "md", "lg", "xl", "custom"], var.config.hardware_preset)
  }

  validation {
    error_message = "For the 'custom' hardware preset, the following values under 'config.advanced.hardware' are required: 'core_count', 'memory_capacity' and 'storage_capacity'."
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
    error_message = "The following values under 'config.advanced.hardware' can only be set for the 'custom' hardware preset: 'core_count', 'memory_capacity' and 'storage_capacity'."
    condition = (
      contains(["custom"], var.config.hardware_preset) ||
      (
        try(var.config.advanced.hardware.core_count == null, true) &&
        try(var.config.advanced.hardware.memory_capacity == null, true) &&
        try(var.config.advanced.hardware.storage_capacity == null, true)
      )
    )
  }
}

# Global variables

variable "namespace" {}

variable "stage" {}

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
  description = "A collection of all the K3S cluster's configuration options"
  type = object({
    name                 = string
    node_count           = optional(number, 3)
    node_hardware_preset = optional(string, "md")
    ssh_keys             = optional(list(string), [])

    advanced = optional(object({
      proxmox = optional(object({
        allowed_nodes = optional(list(string))
        vm_storage    = optional(string)
        vm_bridge     = optional(string)
        vm_vlan_tag   = optional(number)
      }))
    }))
  })
}

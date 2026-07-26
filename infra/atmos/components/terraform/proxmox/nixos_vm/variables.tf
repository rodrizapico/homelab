# Global variables

variable "namespace" {}

variable "stage" {}

# Component specific variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url   = string
    api_token = string
  })
}

variable "config" {
  description = "A collection of all VM's configuration options. Look at ../_modules/linux_vm for a list of available options"
  type        = any
}


variable "nixos_config" {
  description = "A collection of all configuration options related to NixOS"
  type = object({
    flake_path = string
    preset     = string

    user = optional(object({
      name     = optional(string, "nixos")
      ssh_keys = optional(list(string), [])
      }), {
      name     = "nixos",
      ssh_keys = []
    })
  })
}

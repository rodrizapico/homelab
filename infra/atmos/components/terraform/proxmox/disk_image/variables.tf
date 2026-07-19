# Global variables

variable "namespace" {}

variable "stage" {}

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url             = string
    api_token           = string
    ssh_user            = optional(string)
    default_node        = optional(string)
    default_iso_storage = optional(string, "local")
    default_vm_storage  = optional(string, "local-lvm")
    default_vm_bridge   = optional(string, "vmbr0")
    default_vm_vlan_tag = optional(string)
  })
}

# Component specific variables

variable "config" {
  description = "A collection of all the image's configuration options"
  type = object({
    name        = string
    url         = string
    node        = optional(string)
    iso_storage = optional(string)
  })
}

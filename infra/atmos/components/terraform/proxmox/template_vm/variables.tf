# Global variables

variable "namespace" {}

variable "stage" {}

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url             = string
    api_token           = string
    ssh_user            = string
    default_iso_storage = optional(string, "local")
    default_vm_storage  = optional(string, "local-lvm")
    default_vm_bridge   = optional(string, "vmbr0")
    default_vm_vlan_tag = optional(string)
  })
}

# Component specific variables

variable "config" {
  description = "A collection of all the template VM's configuration options"
  type = object({
    name        = string
    description = optional(string)
    node        = string

    image = object({
      url       = string
      file_name = string
    })

    advanced = optional(object({
      proxmox = optional(object({
        iso_storage = optional(string)
        vm_storage  = optional(string)
        vm_bridge   = optional(string)
        vm_vlan_tag = optional(number)
      }))
    }))
  })
}

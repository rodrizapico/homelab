# Global variables

variable "namespace" {}

variable "stage" {}

# Component specific variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url     = string
    api_token   = string
    ssh_user    = string
    node        = optional(string)
    iso_storage = optional(string, "local")
  })
}

variable "config" {
  description = "A collection of all the snippet's configuration options"
  type = object({
    name = string
    data = string
  })
}

# Global variables

variable "namespace" {}

variable "stage" {}

# Component specific variables

variable "proxmox" {
  description = "Proxmox cluster configuration"
  type = object({
    api_url     = string
    api_token   = string
    node        = optional(string)
    iso_storage = optional(string)
  })
}

variable "config" {
  description = "A collection of all the image's configuration options"
  type = object({
    name = string
    url  = string
  })
}

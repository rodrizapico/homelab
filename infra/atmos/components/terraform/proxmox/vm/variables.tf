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

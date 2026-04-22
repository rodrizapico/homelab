terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.103.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

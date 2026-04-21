terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

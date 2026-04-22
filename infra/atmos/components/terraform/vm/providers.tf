provider "proxmox" {
  insecure  = true
  endpoint  = var.proxmox.api_url
  api_token = var.proxmox.api_token
}


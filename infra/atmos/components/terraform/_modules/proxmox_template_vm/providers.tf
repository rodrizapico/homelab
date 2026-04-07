provider "proxmox" {
  pm_api_url      = var.proxmox.api_url
  pm_tls_insecure = true
}

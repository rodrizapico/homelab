
resource "proxmox_download_file" "disk_image" {
  content_type        = "import"
  datastore_id        = var.proxmox.iso_storage
  node_name           = var.proxmox.node
  url                 = var.config.url
  file_name           = "${var.namespace}-${var.stage}-${var.config.name}"
  overwrite           = true
  overwrite_unmanaged = false
}

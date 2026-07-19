
resource "proxmox_download_file" "disk_image" {
  content_type        = "import"
  datastore_id        = coalesce(var.config.iso_storage, var.proxmox.default_iso_storage)
  node_name           = coalesce(var.config.node, var.proxmox.default_node)
  url                 = var.config.url
  file_name           = "${var.namespace}-${var.stage}-${var.config.name}"
  overwrite           = true
  overwrite_unmanaged = false
}

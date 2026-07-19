
resource "proxmox_virtual_environment_file" "snippet" {
  content_type = "snippets"
  datastore_id = var.proxmox.iso_storage
  node_name    = var.proxmox.node

  source_raw {
    file_name = "${var.namespace}-${var.stage}-${var.config.name}"
    data      = var.config.data
  }
}

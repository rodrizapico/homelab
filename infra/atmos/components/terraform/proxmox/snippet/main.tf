
resource "proxmox_virtual_environment_file" "snippet" {
  content_type = "snippets"
  datastore_id = coalesce(var.config.iso_storage, var.proxmox.default_iso_storage)
  node_name    = coalesce(var.config.node, var.proxmox.default_node)

  source_raw {
    file_name = "${var.namespace}-${var.stage}-${var.config.name}"
    data      = var.config.data
  }
}

locals {
  iso_storage = coalesce(var.config.advanced.proxmox.iso_storage, var.proxmox.default_iso_storage)
  name_prefix = "${var.namespace}-${var.stage}"
}


resource "proxmox_download_file" "vm_disk_image" {
  content_type        = "import"
  datastore_id        = local.iso_storage
  node_name           = var.config.node
  url                 = var.config.image.url
  file_name           = "${local.name_prefix}-${var.config.image.file_name}"
  overwrite           = true
  overwrite_unmanaged = false
}


resource "proxmox_virtual_environment_file" "vendor_data_cloud_config" {
  content_type = "snippets"
  datastore_id = local.iso_storage
  node_name    = var.config.node

  source_raw {
    data = <<-EOF
    #cloud-config
    packages:
      - qemu-guest-agent
    package_update: true
    power_state:
      mode: reboot
      timeout: 30
    EOF

    file_name = "${local.name_prefix}-vendor-data-cloud-config.yaml"
  }
}

module "template_vm" {
  source = "../_modules/linux_vm"
  providers = {
    proxmox = proxmox
  }

  proxmox = var.proxmox

  config = {
    name        = "${local.name_prefix}-template-${var.config.name}"
    tags        = [var.namespace, var.stage]
    description = var.config.description

    node            = var.config.node
    disk_image_id   = proxmox_download_file.vm_disk_image.id
    hardware_preset = "md"

    advanced = {
      proxmox  = var.config.advanced.proxmox
      template = true

      cloud_init = {
        vendor_data_file_id = proxmox_virtual_environment_file.vendor_data_cloud_config.id
      }
    }

  }
}

module "vm" {
  source = "../_modules/linux_vm"
  providers = {
    proxmox = proxmox
  }

  proxmox = var.proxmox

  config = {
    name        = "${var.namespace}-${var.stage}-vm-${var.config.name}"
    tags        = [var.namespace, var.stage]
    description = var.config.description

    node     = var.config.node
    clone_id = var.config.template_id

    user            = var.config.user
    hardware_preset = var.config.hardware_preset

    advanced = var.config.advanced
  }
}


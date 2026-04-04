module proxmox_template_vm {
  source   = "../_modules/proxmox_template_vm"

  config = {
    general  = {
      name             = "${var.namespace}-${var.stage}-vm-${var.config.name}"
      tags             = [var.namespace, var.stage]
      proxmox_host     = var.config.proxmox.host
      proxmox_template = var.config.proxmox.template
    }

    hardware = var.config.hardware
    settings = var.config.settings
    nixos    = var.config.nixos
  }
}


module proxmox_template_vm {
  source = "../_modules/proxmox_template_vm"

  proxmox = var.proxmox
  config  = {
    name = "${var.namespace}-${var.stage}-vm-${var.config.name}"
    tags = [var.namespace, var.stage]

    hardware = var.config.hardware
    settings = var.config.settings
    nixos    = var.config.nixos
    advanced = var.config.advanced
  }
}


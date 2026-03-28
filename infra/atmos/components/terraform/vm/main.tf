module proxmox_template_vm {
  source   = "../_modules/proxmox_template_vm"
  general  = {
    name             = "${var.namespace}-${var.stage}-vm-${var.name}"
    tags             = "${var.namespace},${var.stage}"
    proxmox_host     = var.proxmox.host
    proxmox_template = var.proxmox.template
  }

  hardware = var.hardware
  settings = var.settings
  nixos    = var.nixos
}


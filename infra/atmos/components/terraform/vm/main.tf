module proxmox_template_vm {
  source = "../_modules/proxmox_template_vm"

  proxmox          = var.proxmox
  nixos_flake_path = var.nixos_flake_path

  config  = {
    name = "${var.namespace}-${var.stage}-vm-${var.config.name}"
    tags = [var.namespace, var.stage]
    user = var.config.user

    os_preset         = var.config.os_preset
    os_preset_options = var.config.os_preset_options
    hardware_preset   = var.config.hardware_preset

    advanced = var.config.advanced
  }
}


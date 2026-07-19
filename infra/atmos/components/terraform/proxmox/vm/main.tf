module "vm" {
  source = "../_modules/linux_vm"
  providers = {
    proxmox = proxmox
  }

  config = merge(var.config, {
    name = "${var.namespace}-${var.stage}-vm-${var.config.name}",
    tags = [var.namespace, var.stage]
  })
}

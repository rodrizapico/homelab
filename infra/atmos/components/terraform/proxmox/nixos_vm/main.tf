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

module "nixos_deployment" {
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "${var.nixos_config.flake_path}#nixosConfigurations.${var.nixos_config.preset}.config.system.build.toplevel"
  nixos_partitioner_attr = "${var.nixos_config.flake_path}#nixosConfigurations.${var.nixos_config.preset}.config.system.build.diskoScript"
  target_host            = module.vm.ipv4_address
  target_user            = module.vm.ssh_user
  install_ssh_key        = module.vm.generated_ssh_private_key
  deployment_ssh_key     = module.vm.generated_ssh_private_key

  special_args = {
    terraform = {
      hostname = module.vm.name
      username = var.nixos_config.user.name
      ssh_keys = var.nixos_config.user.ssh_keys
      options  = null
    }
  }
}


resource "random_password" "k3s_cluster_token" {
  length  = 64
  special = true
}

module "k3s_cluster_master_node" {
  source = "../_modules/proxmox_template_vm"
  providers = {
    proxmox = proxmox
  }

  proxmox          = var.proxmox
  nixos_flake_path = var.nixos_flake_path

  config = {
    name = "${var.namespace}-${var.stage}-k3s-${var.config.name}-0"
    tags = [var.namespace, var.stage]

    user = {
      name     = "k3s"
      ssh_keys = var.config.ssh_keys
    }

    hardware_preset = var.config.node_hardware_preset
    os_preset       = "k3s_server"
    os_preset_options = {
      k3s_cluster_init  = true
      k3s_cluster_token = random_password.k3s_cluster_token.result
    }

    advanced = var.config.advanced
  }
}

module "k3s_cluster_slave_nodes" {
  source = "../_modules/proxmox_template_vm"
  providers = {
    proxmox = proxmox
  }

  count = var.config.node_count - 1

  proxmox          = var.proxmox
  nixos_flake_path = var.nixos_flake_path

  config = {
    name = "${var.namespace}-${var.stage}-k3s-${var.config.name}-${count.index + 1}"
    tags = [var.namespace, var.stage]

    hardware_preset = var.config.node_hardware_preset
    os_preset       = "k3s_server"
    os_preset_options = {
      k3s_cluster_token = random_password.k3s_cluster_token.result
      k3s_server_addr   = "https://${module.k3s_cluster_master_node.ipv4_address}:6443"
    }

    advanced = var.config.advanced
  }
}


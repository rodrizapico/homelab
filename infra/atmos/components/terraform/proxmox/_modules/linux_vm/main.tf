resource "tls_private_key" "ssh_key" {
  count = var.config.user.generate_ssh_keys ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_virtual_environment_vm" "linux_vm" {
  node_name   = var.config.node
  name        = var.config.name
  vm_id       = var.config.vm_id
  tags        = var.config.tags
  description = var.config.description

  dynamic "clone" {
    for_each = var.config.clone_id != null ? [1] : []

    content {
      vm_id = local.vm.clone_id
    }
  }

  agent {
    enabled = true
    wait_for_ip {
      ipv4 = true
      ipv6 = false
    }
  }

  # VM Settings
  machine       = "q35"
  bios          = "ovmf"
  template      = local.vm.template
  started       = !local.vm.template
  on_boot       = local.settings.autostart
  scsi_hardware = "virtio-scsi-pci"

  operating_system {
    type = "l26"
  }

  cpu {
    cores = local.hardware.core_count
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.hardware.memory_capacity
    floating  = local.hardware.memory_capacity
  }

  efi_disk {
    datastore_id      = local.hardware.storage_location
    type              = "2m"
    pre_enrolled_keys = false
  }

  disk {
    datastore_id = local.hardware.storage_location
    interface    = "scsi0"
    import_from  = local.vm.disk_image_id
    size         = local.hardware.storage_capacity
    discard      = "on"
    ssd          = true
  }

  tpm_state {
    datastore_id = local.hardware.storage_location
  }

  network_device {
    model   = "virtio"
    bridge  = local.hardware.bridge
    vlan_id = local.hardware.vlan_tag
  }

  startup {
    order = local.settings.startup_shutdown_order
  }

  # Cloud Init settings
  initialization {
    datastore_id        = local.hardware.storage_location
    vendor_data_file_id = local.cloud_init.vendor_data_file_id

    ip_config {
      ipv4 {
        address = local.cloud_init.ip_config.ipv4.address
        gateway = local.cloud_init.ip_config.ipv4.gateway
      }
    }

    user_account {
      username = local.cloud_init.username
      keys     = var.config.user.generate_ssh_keys ? [tls_private_key.ssh_key[0].public_key_openssh] : local.cloud_init.ssh_keys
    }
  }

  lifecycle {
    ignore_changes = [node_name, started, initialization["ip_config"]]
  }
}

check "reachability_check" {
  assert {
    error_message = "Your resource might be unreachable since no SSH keys were provided (as 'config.user.ssh_keys'), and 'config.user.generate_ssh_keys' is false"
    condition     = var.config.user.generate_ssh_keys || length(var.config.user.ssh_keys) > 0
  }
}

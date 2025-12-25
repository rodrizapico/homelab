module vm_label {
  source   = "cloudposse/label/null"
  version  = "0.25.0"

  namespace  = var.namespace
  stage      = var.stage
  name       = "vm"
  attributes = [var.vm_name]
}

resource proxmox_vm_qemu vm {
  name        = module.vm_label.id
  tags        = var.stage
  target_node = var.proxmox_host
  clone       = var.template_name
  full_clone  = true

  # VM Settings
  agent     = 1
  skip_ipv6 = true
  os_type   = "cloud-init"
  scsihw    = "virtio-scsi-pci"

  cpu {
    cores = var.core_count
  }

  memory = var.memory_capacity

  disk {
    type       = "disk"
    slot       = "scsi0"
    format     = "raw"
    size       = var.disk_capacity
    storage    = var.disk_storage_location
    emulatessd = true
    discard    = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan_tag
  }

  startup_shutdown {
    order            = var.startup_shutdown_order
    shutdown_timeout = -1
    startup_delay    = -1
  }

  # Cloud Init settings
  ciuser    = var.cloud_init_user
  sshkeys   = var.cloud_init_ssh_key
  ciupgrade = false
  ipconfig0 = var.cloud_init_ip_config
}
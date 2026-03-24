# Global variables

variable namespace {
}

variable stage {
}

# What and where to provision it

variable vm_name {
}

variable proxmox_host {
}

variable template_name {
}

# VM settings

variable autostart {
  default = true
}

variable core_count {
  default = 1
}

variable memory_capacity {
  default = 1024
}

variable disk_capacity {
  default = "32G"
}

variable disk_storage_location {
}

variable bridge {
}

variable vlan_tag {
}

variable startup_shutdown_order {
  default = -1
}

# Cloud Init settings

variable cloud_init_user {
  default = "opentofu"
}

variable cloud_init_ip_config {
}

# Nixos specifics

variable nixos_flake {
  description = "The flake that's going to be used configure the VM"
  type        = object({
    path               = string
    configuration_name = string
  })
}

variable nixos_user {
  description = "The admin user that should be set up inside the VM"
  type        = object({
    name     = string
    ssh_keys = list(string)
  })
}

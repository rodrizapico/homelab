output "name" {
  description = "The deployed VM's name"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "ipv4_address" {
  description = "The deployed VM's ipv4 address"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
}

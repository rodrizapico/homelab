output "id" {
  description = "The deployed VM's id"
  value       = proxmox_virtual_environment_vm.linux_vm.id
}

output "name" {
  description = "The deployed VM's name"
  value       = proxmox_virtual_environment_vm.linux_vm.name
}

output "ipv4_address" {
  description = "The deployed VM's ipv4 address"
  value       = try(proxmox_virtual_environment_vm.linux_vm.ipv4_addresses[1][0], null)
}

output "name" {
  description = "The deployed VM's name"
  value       = proxmox_vm_qemu.vm.name
}

output "ipv4_address" {
  description = "The deployed VM's ipv4 address"
  value       = proxmox_vm_qemu.vm.default_ipv4_address
}

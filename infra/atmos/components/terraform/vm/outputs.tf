output "name" {
  description = "The deployed VM's name"
  value       = module.proxmox_template_vm.name
}

output "ipv4_address" {
  description = "The deployed VM's ipv4 address"
  value       = module.proxmox_template_vm.ipv4_address
}

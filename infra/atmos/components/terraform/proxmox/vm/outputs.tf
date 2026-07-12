output "id" {
  description = "The deployed VM's id"
  value       = module.vm.id
}

output "name" {
  description = "The deployed VM's name"
  value       = module.vm.name
}

output "ipv4_address" {
  description = "The deployed VM's ipv4 address"
  value       = module.vm.ipv4_address
}

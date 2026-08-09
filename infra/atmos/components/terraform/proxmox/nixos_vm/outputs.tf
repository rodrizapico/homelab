output "node" {
  description = "The VM's node"
  value       = module.vm.node
}

output "id" {
  description = "The VM's id"
  value       = module.vm.id
}

output "name" {
  description = "The VM's name"
  value       = module.vm.name
}

output "ipv4_address" {
  description = "The VM's ipv4 address"
  value       = module.vm.ipv4_address
}

output "ssh_user" {
  description = "The SSH username"
  value       = module.vm.ssh_user
}

output "generated_ssh_public_key" {
  description = "The SSH public key, if generated"
  value       = module.vm.generated_ssh_public_key
}

output "generated_ssh_private_key" {
  description = "The SSH private key, if generated"
  value       = module.vm.generated_ssh_private_key
  sensitive   = true
}

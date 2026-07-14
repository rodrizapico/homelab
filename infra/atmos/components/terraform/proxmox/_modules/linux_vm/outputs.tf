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

output "ssh_user" {
  description = "The SSH username"
  value       = local.cloud_init.username
}

output "generated_ssh_public_key" {
  description = "The SSH public key, if generated"
  value       = try(tls_private_key.ssh_key[0].public_key_openssh, null)
}

output "generated_ssh_private_key" {
  description = "The SSH private key, if generated"
  value       = try(tls_private_key.ssh_key[0].private_key_openssh, null)
}

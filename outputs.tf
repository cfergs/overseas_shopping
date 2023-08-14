output "vm_IP" {
  value = data.publicip_address.ip_address.ip
}

output "vm_username" {
  value = var.username
}

output "vm_password" {
  value = random_string.password_generation.result
}

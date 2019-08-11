output "vm_IP" {
  value = "${data.azurerm_public_ip.ip.ip_address}"
}

output "vm_username" {
  value = "shoppingvm"
}

output "vm_password" {
  value = "${var.password}"
}
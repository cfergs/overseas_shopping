output "vm_name" {
  value = "${azurerm_virtual_machine.vm.name}"
}

output "vm_username" {
  value = "shoppingvm"
}

output "vm_password" {
  value = "${var.password}"
}
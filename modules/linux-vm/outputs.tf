output "private_ip" {
  value = azurerm_linux_virtual_machine.this.private_ip_address
}

output "public_ip" {
  value = var.public ? azurerm_linux_virtual_machine.this.public_ip_address : null
}

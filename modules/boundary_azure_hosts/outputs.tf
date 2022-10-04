output "azure_vm_instance_public_address" {
  value = azurerm_public_ip.catapp-pip.fqdn
}

output "azure_vm_instance_private_address" {
  value = azurerm_network_interface.catapp-nic.private_ip_address
}
output "azure_vm_instance_public_address" {
  value = azurerm_public_ip.catapp-pip.fqdn
}


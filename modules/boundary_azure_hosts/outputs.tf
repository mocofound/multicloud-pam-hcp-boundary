output "azure_vm_instance_public_address" {
  value = azurerm_public_ip.catapp-pip.ip_address
}

output "azure_vm_hcp_worker_instance_public_address" {
  value = azurerm_public_ip.hcp-worker-pip.ip_address
}

output "azure_vm_instance_private_address" {
  value = azurerm_network_interface.catapp-nic.private_ip_address
}

output "azure_tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "azure_aks_cluster_fqdn" {
  value = module.aks.cluster_fqdn
}

output "azure_aks_cluster_private_fqdn" {
  value = module.aks.cluster_private_fqdn
}

output "azure_windows_rdp_address" {
  value = azurerm_windows_virtual_machine.azure-rdp-vm.private_ip_address
}

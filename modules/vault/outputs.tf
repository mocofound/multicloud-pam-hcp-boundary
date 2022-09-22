output "periodic_no_parent_renewable_vault_token" {
  value = vault_token.boundary_token.client_token
}

output "periodic_no_parent_renewable_vault_token_azure" {
  value = vault_token.boundary_token_azure.client_token
}
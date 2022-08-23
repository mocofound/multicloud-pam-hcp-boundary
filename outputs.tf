output "boundary_password_auth_method_id" {
  value = var.boundary_password_auth_method_id
}

output "boundary_login_name" {
  value = var.boundary_login_name
}

output "boundary_login_password" {
  value = var.boundary_login_password
}

output "boundary_addr" {
  value = var.boundary_controller_address
}

output "boundary_vault_credential_store" {
  value = boundary_credential_store_vault.vault_cred_store.id
}

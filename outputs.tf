output "boundary_password_auth_method_id" {
  #value = module.hcp_boundary_cluster
  #value = var.boundary_password_auth_method_id
  #value = module.hcp_boundary_cluster.boundary_password_auth_method_id
  value = local.auth_method_id
}

output "boundary_login_name" {
  value = module.hcp_boundary_cluster.boundary_login_name
}

output "boundary_login_password" {
  value = module.hcp_boundary_cluster.boundary_login_password
  sensitive = true
}

output "boundary_addr" {
  value = module.hcp_boundary_cluster.boundary_addr
}

# output "boundary_vault_credential_store" {
#   value = boundary_credential_store_vault.vault_cred_store.id
# }

output "gcp_region" {
  value = var.gcp_region
}

output "boundary_dynamic_host_catalog_aws_iam_access_key_secret" {
  value = module.boundary.boundary_dynamic_host_catalog_aws_iam_access_key_secret
  sensitive = true
}
output "boundary_dynamic_host_catalog_aws_iam_access_key_id" {
  value = module.boundary.boundary_dynamic_host_catalog_aws_iam_access_key_id
  sensitive = true
}
output "boundary_dynamic_host_catalog_aws_iam_access_key_user" {
  value = module.boundary.boundary_dynamic_host_catalog_aws_iam_access_key_user
  sensitive = true
}
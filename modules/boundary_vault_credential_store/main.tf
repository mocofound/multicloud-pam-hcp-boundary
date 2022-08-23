resource "boundary_credential_store_vault" "vault_cred_store" {
  name        = var.name
  description = var.description
  address     = var.vault_address     # change to Vault address
  namespace   = var.vault_namespace
  token       = var.periodic_no_parent_renewable_vault_token             # change to valid periodic, no_parent, renewable Vault token
  scope_id    = var.boundary_scope_id
}

resource "boundary_credential_library_vault" "postgres_cred_library" {
  name                = "postgres_cred_library"
  description         = "Vault credential library for postgres access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "postgres/creds/postgres_db_role"    # change to Vault backend path
  http_method         = "GET"
}

/*
resource "boundary_credential_library_vault" "aws_ssh" {
  name                = "aws_ssh"
  description         = "Vault credential library for AWS ssh access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "kv/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  #Note: credential type parameter is not available as of v1.0.10 of the Boundary Terraform Provider
  #Use CLI to create credential-library with flag -credential-type=ssh_private_key
  #boundary credential-libraries create vault -credential-store-id csvlt_DlGIWbswKx -vault-path "kv/data/my-secret" -credential-type=ssh_private_key

  #credential_type     = "ssh_private_key"
}
*/
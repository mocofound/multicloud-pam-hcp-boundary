resource "boundary_credential_library_vault" "aws_ssh" {
  name                = "aws_ssh"
  description         = "Vault credential library for AWS ssh access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "kv/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "ssh_private_key"
}


resource "boundary_credential_library_vault" "postgres_cred_library" {
  name                = "postgres_cred_library"
  description         = "Vault credential library for postgres access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "postgres/creds/postgres_db_role"
  http_method         = "GET"
}
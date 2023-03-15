resource "boundary_credential_library_vault" "aws_ssh" {
  name                = "aws_ssh"
  description         = "Vault credential library for AWS ssh access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "kv/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "ssh_private_key"
}

resource "boundary_credential_library_vault" "nomad_ssh" {
  name                = "nomad_ssh"
  description         = "Vault credential library for nomad ssh access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "kv/data/my-nomad-secret" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "ssh_private_key"
}

resource "boundary_credential_library_vault" "azure_windows_rdp" {
  name                = "azure_windows_rdp"
  description         = "Vault credential library for azure_windows_rdp"
  credential_store_id = boundary_credential_store_vault.vault_cred_store_azure.id
  path                = "kv/data/my-secret-rdp" # change to Vault backend path
  http_method         = "GET"
  #credential_type     = "ssh_private_key"
}

resource "boundary_credential_library_vault" "azure_windows_rdp_v1" {
  name                = "azure_windows_rdp_v1"
  description         = "Vault credential library for azure_windows_rdp"
  credential_store_id = boundary_credential_store_vault.vault_cred_store_azure.id
  path                = "kvv1/my-secret-rdp" # change to Vault backend path
  http_method         = "GET"
  #credential_type     = "ssh_private_key"
}

# resource "boundary_credential_library_vault" "aws_windows_rdp" {
#   name                = "aws_windows_rdp"
#   description         = "Vault credential library for aws_windows_rdp"
#   credential_store_id = boundary_credential_store_vault.vault_cred_store.id
#   path                = "kv/data/my-secret" # change to Vault backend path
#   http_method         = "GET"
#   credential_type     = "ssh_private_key"
# }

resource "boundary_credential_library_vault" "azure_ssh" {
  name                = "azure_ssh"
  description         = "Vault credential library for Azure ssh access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store_azure.id
  path                = "kv/data/my-secret-azure" # change to Vault backend path
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
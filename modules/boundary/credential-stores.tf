resource "boundary_credential_store_vault" "vault_cred_store" {
  name        = var.credential_store_name
  description = var.credential_store_description
  address     = var.vault_address
  namespace   = var.vault_namespace
  token       = var.periodic_no_parent_renewable_vault_token          # change to valid periodic, no_parent, renewable Vault token
  scope_id    = boundary_scope.project_aws.id

  depends_on = [
  ]
}

variable "credential_store_name" {
  default = "boundary_cred_store_2"
}









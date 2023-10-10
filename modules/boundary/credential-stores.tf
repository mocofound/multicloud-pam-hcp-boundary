locals {
  aws_credential_store_name = "boundary_cred_store_aws"
  azure_credential_store_name = "boundary_cred_store_azure"
  tde_credential_store_name = "boundary_cred_store_tde"
}

resource "boundary_credential_store_vault" "vault_cred_store" {
  name        = local.aws_credential_store_name
  description = var.credential_store_description
  address     = var.vault_address
  namespace   = var.vault_namespace
  token       = var.periodic_no_parent_renewable_vault_token
  scope_id    = boundary_scope.project_aws.id

  depends_on = [
  ]
}

resource "boundary_credential_store_vault" "vault_cred_store_tde" {
  name        = local.tde_credential_store_name
  description = "var.credential_store_description33"
  address     = var.vault_address
  namespace   = var.vault_namespace
  token       = var.periodic_no_parent_renewable_vault_token_tde
  
  scope_id    = boundary_scope.project_tde.id

  depends_on = [
  ]
}

# resource "boundary_credential_store_vault" "vault_cred_store_azure" {
#   name        = local.azure_credential_store_name
#   description = "vault credential store for Azure"
#   address     = var.vault_address
#   namespace   = var.vault_namespace
#   token       = var.periodic_no_parent_renewable_vault_token_azure
#   scope_id    = boundary_scope.project_azure.id

#   depends_on = [
#   ]
# }

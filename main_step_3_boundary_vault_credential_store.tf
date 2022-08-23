
module "vault" {
  source = "./modules/vault"
  boundary_aws_targets = module.boundary_aws_targets
  #ssh_key = module.boundary_aws_targets.ssh_private_key
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password =  var.aws_db_instance_login_password
    
  depends_on = [
    module.hcp_vault
  ]
}

/*
module "boundary_vault_credential_store" {
  source              = "./modules/boundary_vault_credential_store"
  name                = var.credential_store_name
  description         = var.credential_store_description
  vault_address       = module.hcp_vault.hcp_vault_cluster_public_ip
  vault_namespace     = var.hcp_vault_namespace
  periodic_no_parent_renewable_vault_token          = module.vault.periodic_no_parent_renewable_vault_token
  boundary_scope_id   = module.boundary.boundary_scope_project_aws_id

  depends_on = [
    module.vault,
    module.boundary
  ]
}
*/

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


resource "boundary_credential_store_vault" "vault_cred_store" {
  name        = var.credential_store_name
  description = var.credential_store_description
  address     = module.hcp_vault.hcp_vault_cluster_public_ip
  namespace   = var.hcp_vault_namespace
  token       = module.vault.periodic_no_parent_renewable_vault_token          # change to valid periodic, no_parent, renewable Vault token
  scope_id    = module.boundary.boundary_scope_project_aws_id

  depends_on = [
    module.boundary,
    module.vault
  ]
}

resource "boundary_credential_library_vault" "postgres_cred_library" {
  name                = "postgres_cred_library"
  description         = "Vault credential library for postgres access"
  credential_store_id = boundary_credential_store_vault.vault_cred_store.id
  path                = "postgres/creds/postgres_db_role"
  http_method         = "GET"
}

resource "boundary_target" "aws_ssh" {
  name         = "aws_ec2_ssh_target"
  description  = "aws_ec2_ssh_target"
  type         = "tcp"
  default_port = "22"
  scope_id     = module.boundary.boundary_scope_project_aws_id
  host_source_ids = [
    module.boundary.boundary_host_set_static_aws_ssh,
  ]

  #Note: credential type parameter is not available as of v1.0.10 of the Boundary Terraform Provider
  #Use CLI create credential-library with flag -credential-type=ssh_private_key
  #boundary credential-libraries create vault -credential-store-id csvlt_DlGIWbswKx -vault-path "kv/data/my-secret" -credential-type=ssh_private_key
  #Then, manually update application_credential_source_ids to include credentiallibraryid
  application_credential_source_ids = [
    "clvlt_ZapyisQdTY",
    #boundary_credential_library_vault.aws_ssh.id,
  ]
  
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres_db_target"
  description              = "Backend postgres target"
  scope_id                 = module.boundary.boundary_scope_project_aws_id
  default_port             = 5432
  session_connection_limit = -1
  application_credential_source_ids = [
    boundary_credential_library_vault.postgres_cred_library.id
  ]
  host_source_ids = [
    module.boundary.boundary_host_set_static_postgres
  ]
  depends_on = [
    module.boundary
  ]
}

variable "credential_store_name" {
  default = "boundary_cred_store_1"
}

variable "credential_store_description" {
    default = "boundary_cred_store_1"
}

variable "vault_address" {
    default = "changeme"
}

variable "boundary_scope_id" {
    default = "changeme"
}

variable "periodic_no_parent_renewable_vault_token" {
  default = "changeme"
}
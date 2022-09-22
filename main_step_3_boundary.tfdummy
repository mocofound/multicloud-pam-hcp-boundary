provider "boundary" {
  addr                             = var.boundary_controller_address
  auth_method_id                   = var.boundary_password_auth_method_id
  password_auth_method_login_name  = var.boundary_login_name        
  password_auth_method_password    = var.boundary_login_password
}

module "boundary" {
  source = "./modules/boundary"
  vault_address                = module.hcp_vault.hcp_vault_cluster_public_ip
  vault_token                  = module.hcp_vault.hcp_vault_cluster_admin_token
  vault_namespace              = var.vault_namespace
  periodic_no_parent_renewable_vault_token = module.vault.periodic_no_parent_renewable_vault_token
  aws_ec2_instance             = module.boundary_aws_targets.aws_ec2_instance.public_dns
  aws_rds_db                   = module.boundary_aws_targets.aws_rds_db.address
  boundary_controller_address  = var.boundary_controller_address
  aad_client_id                = var.aad_client_id
  aad_client_secret_value      = var.aad_client_secret_value
  aad_tenant_id                = var.aad_tenant_id
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_targets,
    module.vault,
  ]
}

output "boundary_oidc_auth_method_id" {
  value = module.boundary.boundary_oidc_auth_method_id
}
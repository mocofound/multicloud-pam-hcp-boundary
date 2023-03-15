
locals {
  auth_method_id = "ampw_ocFcdIi8Oa"
}

provider "boundary" {
  addr                             = module.hcp_boundary_cluster.boundary_addr
  #addr = var.boundary_controller_address

  #auth_method_id = module.hcp_boundary_cluster.boundary_password_auth_method_id
  auth_method_id = local.auth_method_id
  #auth_method_id = var.boundary_password_auth_method_id

  password_auth_method_login_name  = module.hcp_boundary_cluster.boundary_login_name

  #password_auth_method_login_name = var.boundary_login_name
  password_auth_method_password    = module.hcp_boundary_cluster.boundary_login_password

  #password_auth_method_password = var.boundary_login_password
}

module "boundary" {
  source = "./modules/boundary"
    #boundary_controller_address  = var.boundary_controller_address
  boundary_controller_address     = module.hcp_boundary_cluster.boundary_addr
  vault_address                = module.hcp_vault.hcp_vault_cluster_public_ip
  vault_token                  = module.hcp_vault.hcp_vault_cluster_admin_token
  vault_namespace              = var.vault_namespace
  periodic_no_parent_renewable_vault_token = module.vault.periodic_no_parent_renewable_vault_token
  periodic_no_parent_renewable_vault_token_azure = module.vault.periodic_no_parent_renewable_vault_token_azure
  aws_ec2_instance             = module.boundary_aws_hosts.aws_ec2_instance.public_dns
  aws_rds_db                   = module.boundary_aws_hosts.aws_rds_db.address
  #aws_ec2_windows_instance     = module.boundary_aws_hosts.aws_ec2_windows_instance.public_dns
  aws_ec2_windows_instance     = module.boundary_aws_hosts.aws_ec2_windows_instance.private_ip
  #azure_vm_instance            = module.boundary_azure_hosts.azure_vm_instance_public_address
  azure_vm_instance            = module.boundary_azure_hosts.azure_vm_instance_private_address
  azure_vm_hcp_worker_instance = module.boundary_azure_hosts.azure_vm_hcp_worker_instance_public_address
  aks_cluster_address          = module.boundary_azure_hosts.azure_aks_cluster_fqdn
  #aks_cluster_address          = module.boundary_azure_hosts.azure_aks_cluster_private_fqdn
  azure_windows_rdp_address =  module.boundary_azure_hosts.azure_windows_rdp_address
  # aws_access_key_id = var.aws_access_key_id
  # aws_access_access_key = var.aws_access_access_key
  aad_client_id                = var.aad_client_id
  aad_client_secret_value      = var.aad_client_secret_value
  aad_tenant_id                = var.aad_tenant_id
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_hosts,
    module.boundary_azure_hosts,
    module.vault,
  ]
}

output "boundary_oidc_auth_method_id" {
  value = module.boundary.boundary_oidc_auth_method_id
}

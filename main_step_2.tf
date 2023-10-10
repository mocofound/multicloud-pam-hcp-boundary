 module "vault_aws" {
  source = "./modules/vault"
  count = local.create_aws ? 1 : 0

  hosts = module.boundary_aws_hosts
  #boundary_aws_hosts = module.boundary_aws_hosts
  #boundary_azure_hosts = module.boundary_azure_hosts

  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password =  var.aws_db_instance_login_password
  
  key_name = var.key_name
    
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_hosts,
    module.boundary_azure_hosts
  ]
}

module "boundary_azure_hosts" {
   count = local.create_azure ? 1 : 0
   source = "./modules/boundary_azure_hosts"
   prefix = var.prefix
 }

module "vault_azure" {
  source = "./modules/vault"
  count = local.create_azure ? 1 : 0

  hosts = module.boundary_azure_hosts
  #boundary_aws_hosts = module.boundary_aws_hosts
  #boundary_azure_hosts = module.boundary_azure_hosts

  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password =  var.aws_db_instance_login_password
  
  key_name = var.key_name
    
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_hosts,
    module.boundary_azure_hosts
  ]
}

module "boundary" {
  source = "./modules/boundary"
  # auth_method_id = local.auth_method_id
  boundary_controller_address     = module.hcp_boundary_cluster.boundary_addr
  vault_address                = module.hcp_vault.hcp_vault_cluster_public_ip
  vault_token                  = module.hcp_vault.hcp_vault_cluster_admin_token
  vault_namespace              = var.vault_namespace
  periodic_no_parent_renewable_vault_token = module.vault_aws[0].periodic_no_parent_renewable_vault_token
  periodic_no_parent_renewable_vault_token_tde = module.vault_aws[0].periodic_no_parent_renewable_vault_token_tde
  aws_ec2_instance             = module.boundary_aws_hosts[0].aws_ec2_instance.public_dns
  aws_rds_db                   = module.boundary_aws_hosts[0].aws_rds_db.address
  aws_ec2_windows_instance     = module.boundary_aws_hosts[0].aws_ec2_windows_instance.private_ip
  #azure_vm_instance            = module.boundary_azure_hosts[0].azure_vm_instance_private_address
  #azure_vm_hcp_worker_instance = module.boundary_azure_hosts[0].azure_vm_hcp_worker_instance_public_address
  #aks_cluster_address          = module.boundary_azure_hosts[0].azure_aks_cluster_fqdn
  #azure_windows_rdp_address =  module.boundary_azure_hosts[0].azure_windows_rdp_address
  aad_client_id                = var.aad_client_id
  aad_client_secret_value      = var.aad_client_secret_value
  aad_tenant_id                = var.aad_tenant_id
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_hosts,
    module.boundary_azure_hosts,
    module.vault_aws,
    module.vault_azure,
  ]
}

# module "boundary_worker_registration" {
#   source = "github.com/mocofound/boundary-worker-registration"
#   boundary_cluster_url = module.hcp_boundary_cluster.boundary_addr
#   boundary_username   = var.boundary_login_name
#   boundary_password   = var.boundary_login_password
#   boundary_auth_method_id = local.auth_method_id
#   prefix = var.prefix
#   vpc_id = module.boundary_aws_hosts[0].aws_vpc_id
#   subnet_id = module.boundary_aws_hosts[0].aws_subnet_id
#   initial_upstreams = var.initial_upstreams
#   depends_on = [
#     module.boundary,
#   ]
# }

# output "boundary_worker_registration" {
#   value = module.boundary_worker_registration.boundary_worker_registration
# }


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
output "boundary_oidc_auth_method_id" {
  value = module.boundary.boundary_oidc_auth_method_id
}


locals {
  create_azure = false
  create_aws = true
  #password auth method id
  auth_method_id = "ampw_sGK2v1lzWX"
  #auth_method_id = module.hcp_boundary_cluster.boundary_password_auth_method_id
}

module "hcp_hvn" {
  source = "./modules/hcp/hcp_hvn"

  prefix = var.prefix
}

module "hcp_vault" {
  source = "./modules/hcp/hcp_vault"
  hcp_boundary_hvn_id = module.hcp_hvn.hcp_boundary_hvn_id
  hcp_vault_tier = var.hcp_vault_tier
  prefix = var.prefix
  
  depends_on = [
    module.hcp_hvn
  ]
}

 
 module "hcp_boundary_cluster" {
  source = "./modules/hcp/hcp_boundary_cluster"
  cluster_id = "${var.prefix}-boundary-cluster"
  username   = var.boundary_login_name
  password   = var.boundary_login_password

  depends_on = [
    module.hcp_vault
  ]
}

# module "app-boundary" {
#   source  = "devops-rob/app-boundary/azuread"
#   version = "0.1.2"
#   # insert the 1 required variable here
#   boundary_redirect_address = module.hcp_boundary_cluster.boundary_addr
# }

module "boundary_aws_hosts" {
  count = local.create_aws ? 1 : 0
  source = "./modules/boundary_aws_hosts"
  region = var.region
  prefix = var.prefix
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password = var.aws_db_instance_login_password
  depends_on = [
  ]
}

# module "oidc_azure_entra" {
#   source = "./modules/oidc/azure_entra"
#   count = 0
#   #prefix = var.prefix
#   depends_on = [
#   ]
# }

# module "boundary_azure_hosts" {
#    count = local.create_azure ? 1 : 0
#    source = "./modules/boundary_azure_hosts"
#    prefix = var.prefix
#  }

# module "vault_azure" {
#   source = "./modules/vault"
#   count = local.create_azure ? 1 : 0

#   hosts = module.boundary_azure_hosts
#   #boundary_aws_hosts = module.boundary_aws_hosts
#   #boundary_azure_hosts = module.boundary_azure_hosts

#   aws_db_instance_login_name = var.aws_db_instance_login_name
#   aws_db_instance_login_password =  var.aws_db_instance_login_password
  
#   key_name = var.key_name
    
#   depends_on = [
#     module.hcp_vault,
#     module.boundary_aws_hosts,
#     module.boundary_azure_hosts
#   ]
# }
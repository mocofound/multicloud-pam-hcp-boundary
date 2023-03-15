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


module "boundary_aws_hosts" {
  source = "./modules/boundary_aws_hosts"
  prefix = var.prefix
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password = var.aws_db_instance_login_password
  depends_on = [
  ]
}

module "boundary_azure_hosts" {
   source = "./modules/boundary_azure_hosts"
   prefix = var.prefix
 }
module "vault" {
  source = "./modules/vault"
  #count = var.create_lc ? 1 : 0
  boundary_aws_targets = module.boundary_aws_targets
  #ssh_key = module.boundary_aws_targets.ssh_private_key
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password =  var.aws_db_instance_login_password
    
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_targets,
  ]
}

provider "vault" { 
  add_address_to_env = true
  address = module.hcp_vault.hcp_vault_cluster_public_ip
  token = module.hcp_vault.hcp_vault_cluster_admin_token
  namespace = var.vault_namespace
  #address = hcp_vault_cluster.boundary_vault_cluster.vault_public_endpoint_url
  #namespace = var.hcp_vault_namespace
  #token = hcp_vault_cluster_admin_token.my_token.token
}
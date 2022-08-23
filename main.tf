// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.40.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "1.0.10"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "=4.26.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.8.2"
    }
}
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

 /*
 #Terraform provider does not allow creation of hcp boundary clusters yet
 #For now, Use HCP cloud portal to manually create cluster
module "hcp-boundary" {
  source = "./modules/hcp/hcp-boundary"
  depends_on = [
    module.hcp_vault
  ]
}
*/

provider "vault" { 
  #address = hcp_vault_cluster.boundary_vault_cluster.vault_public_endpoint_url
  #namespace = var.hcp_vault_namespace
  #token = hcp_vault_cluster_admin_token.my_token.token
  add_address_to_env = true
  address = module.hcp_vault.hcp_vault_cluster_public_ip
  token = module.hcp_vault.hcp_vault_cluster_admin_token
  namespace = var.hcp_vault_namespace
}

module "boundary" {
  source = "./modules/boundary"
  vault_address                = module.hcp_vault.hcp_vault_cluster_public_ip
  vault_token                  = module.hcp_vault.hcp_vault_cluster_admin_token
  aws_ec2_instance             = module.boundary_aws_targets.aws_ec2_instance.public_dns
  aws_rds_db                   = module.boundary_aws_targets.aws_rds_db.address
  boundary_controller_address  = var.boundary_controller_address
  aad_client_id                = var.aad_client_id
  aad_client_secret_value      = var.aad_client_secret_value
  aad_tenant_id                = var.aad_tenant_id
  depends_on = [
    module.hcp_vault,
    module.boundary_aws_targets
  ]
}


provider "boundary" {
  addr                             = var.boundary_controller_address
  auth_method_id                   = var.boundary_password_auth_method_id
  password_auth_method_login_name  = var.boundary_login_name        
  password_auth_method_password    = var.boundary_login_password
}

module "boundary_aws_targets" {
  source = "./modules/boundary_aws_targets"
  prefix = var.prefix
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password = var.aws_db_instance_login_password
  depends_on = [
  ]
}

provider "aws" {
  region  = var.region
}

provider "google" {
  region  = var.gcp_region
}
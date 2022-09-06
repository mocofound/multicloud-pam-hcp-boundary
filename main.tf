// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.40.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "1.0.11"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "=4.26.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~>4.33.0"
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

provider "aws" {
  region  = var.region
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project_id
}

module "boundary_aws_targets" {
  source = "./modules/boundary_aws_targets"
  prefix = var.prefix
  aws_db_instance_login_name = var.aws_db_instance_login_name
  aws_db_instance_login_password = var.aws_db_instance_login_password
  depends_on = [
  ]
}


// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.44.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "~>1.0.12"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "=4.26.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.22.0"
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

 
 module "hcp_boundary_cluster" {
  source = "./modules/hcp/hcp_boundary_cluster"
  cluster_id = "${var.prefix}-boundary-cluster"
  username   = var.boundary_login_name
  password   = var.boundary_login_password

  depends_on = [
    module.hcp_vault
  ]
}

// Configure the HCP provider
provider "hcp" {
#authenticating: https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/guides/auth
#Alternatively, use environment variables
#export HCP_CLIENT_ID="2324242"
#export HCP_CLIENT_SECRET="1234xyz"
client_id = var.hcp_client_id
client_secret = var.hcp_client_secret
}

provider "aws" {
  region  = var.region
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project_id
}

provider "azurerm" {
  features {}
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
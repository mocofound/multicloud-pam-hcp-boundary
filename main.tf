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
      vault = {
      source = "hashicorp/vault"
      version = "3.8.2"
    }
}
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

provider "boundary" {
  addr                            = var.boundary_controller_address
  auth_method_id                  = var.boundary_password_auth_method_id
  password_auth_method_login_name = var.boundary_login_name        
  password_auth_method_password   = var.boundary_login_password
}

provider "vault" { 
  address = hcp_vault_cluster.my_cluster.vault_public_endpoint_url
  token = hcp_vault_cluster_admin_token.my_token.token
  #token = vault_token.boundary_token.client_token
}

/*
provider "vault" {
  alias = "jenkins_namespace"
  address    = var.vault_address
  token      = var.vault_token
  namespace = var.vault_jenkins_namespace
}
*/
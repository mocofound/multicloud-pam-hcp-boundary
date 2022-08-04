// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.38.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "1.0.9"
    }
  }
}

// Configure the HCP provider
provider "hcp" {
#authenticating: https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/guides/auth
#Use environment variables
#export HCP_CLIENT_ID="2324242"
#export HCP_CLIENT_SECRET="1234xyz"
}

provider "boundary" {
  addr                            = var.boundary_controller_address
  auth_method_id                  = var.boundary_auth_method_id
  password_auth_method_login_name = var.boundary_login_name        
  password_auth_method_password   = var.boundary_login_password
}
// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.71.1"
     }
    # boundary = {
    #   source = "hashicorp/boundary"
    #   version = "~>1.1.9"
    # }
    aws = {
      source  = "hashicorp/aws"
      version = "=4.65.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.47.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~>4.63.1"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.20.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~>4.0.4"
    }
    local = {
      source = "hashicorp/local"
      version = "~>2.4.0"
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

 provider "vault" { 
   add_address_to_env = true
   address = module.hcp_vault.hcp_vault_cluster_public_ip
   #address = ""
   token = module.hcp_vault.hcp_vault_cluster_admin_token
   namespace = var.vault_namespace
 }

provider "kubernetes" {
  config_context = "my-context"
  config_path = "~/.kube/config"
  #config_path = "~/.kube/config"
  #KUBE_CONFIG_PATH environment variable

}

# provider "kubernetes" {
#   host = "https://cluster_endpoint:port"

#   client_certificate     = file("~/.kube/client-cert.pem")
#   client_key             = file("~/.kube/client-key.pem")
#   cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
# }

provider "boundary" {
  addr                             = module.hcp_boundary_cluster.boundary_addr
  auth_method_id = local.auth_method_id
  #auth_method_id = data.http.boundary_cluster_auth_methods.id
  auth_method_login_name  = module.hcp_boundary_cluster.boundary_login_name
  auth_method_password    = module.hcp_boundary_cluster.boundary_login_password
  scope_id = "global"
}


// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.55.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "~>1.1.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "=4.58.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.47.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~>4.56.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.13.0"
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
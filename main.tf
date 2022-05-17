// Pin the version
terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.28.0"
    }
  }
}

// Configure the provider
provider "hcp" {}

resource "hcp_vault_cluster" "my_cluster" {
  cluster_id = "hcp-tf-example-vault-cluster"
  hvn_id = "main-hvn"
  public_endpoint = true
#  cloud_provider = "aws"
  

}


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

resource "hcp_hvn" "my_hvn" {
  hvn_id = "main-hvn"
  region = "us-west-2"
  cloud_provider = "aws"
}




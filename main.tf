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

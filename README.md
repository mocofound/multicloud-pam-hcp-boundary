# hcp-boundary-vault-demo

## IMPORTANT
1) manually create HCP Boundary cluster

2) rename .tfdummy file to .tf after initial run then run again to resolve hcp vault, boundary credential store and vault provider dependencies

3) manually create boundary credential library with credential-type=ssh_private_key until it is added in tf provider

## Setup
Install Terraform >v1.0

rename "terraform.tfvars.example" file to "terraform.tfvars"

populate "terraform.tfvars" files with appropriate variables

terraform init

terraform plan

terraform apply

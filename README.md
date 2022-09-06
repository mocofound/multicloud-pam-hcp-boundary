# hcp-boundary-vault-demo

## IMPORTANT
1) manually create HCP Boundary cluster.  Log in to grab password auth method id.

2) rename .tfdummy file(s) to .tf after initial run then run again to resolve hcp vault, boundary credential store and vault provider dependencies.  

3) brew install --cask google-cloud-sdk

4) gcloud init

5) gcloud config set compute/zone us-central1-a

## OIDC Azure AD
Helpful Video: https://www.youtube.com/watch?v=glZR3e9RQAI

## Setup
Install Terraform >v1.0

rename "terraform.tfvars.example" file to "terraform.tfvars"

populate "terraform.tfvars" files with appropriate variables

terraform init

terraform plan

terraform apply

## Error Message

module.boundary.boundary_credential_store_vault.vault_cred_store: Creating...
╷
│ Error: error creating credential store: {"kind":"Internal","message":"credentialstores.(Service).createInRepo: unable to create credential store: vault.(Repository).CreateCredentialStore: vault token is not renewable, vault token issue: error #3012"}
│ 
│   with module.boundary.boundary_credential_store_vault.vault_cred_store,
│   on modules/boundary/boundary-vault-config.tf line 1, in resource "boundary_credential_store_vault" "vault_cred_store":
│    1: resource "boundary_credential_store_vault" "vault_cred_store" {
│ 
╵


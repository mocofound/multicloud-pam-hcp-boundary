# hcp-boundary-pam-multicloud

![HCP Boundary](./assets/Boundary_Diagram_HCP_Workers.png)


## OIDC Azure AD
Helpful Video: https://www.youtube.com/watch?v=glZR3e9RQAI

## Setup
Install Terraform >v1.0

rename "terraform.tfvars.example" file to "terraform.tfvars"

populate "terraform.tfvars" files with appropriate variables

terraform init

terraform plan

terraform apply

rename .tfdummy files to .tf

terraform plan/apply

## IMPORTANT

4) brew install --cask google-cloud-sdk

5) gcloud init

6) gcloud config set compute/zone us-central1-a
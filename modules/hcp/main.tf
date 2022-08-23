// Configure the HCP provider
provider "hcp" {
#authenticating: https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/guides/auth
#Alternatively, use environment variables
#export HCP_CLIENT_ID="2324242"
#export HCP_CLIENT_SECRET="1234xyz"
client_id = var.hcp_client_id
client_secret = var.hcp_client_secret
}
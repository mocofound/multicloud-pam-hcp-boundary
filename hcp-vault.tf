resource "hcp_vault_cluster" "my_cluster" {
  cluster_id = "hcp-tf-boundary-vault-cluster"
  hvn_id = "boundary-hvn"
  public_endpoint = true
  #cloud_provider = "aws"
}

resource "hcp_vault_cluster_admin_token" "my_token" {
  cluster_id = hcp_vault_cluster.my_cluster.cluster_id
}

output "hcp_vault_cluster_admin_token" {
  sensitive = true
  value = hcp_vault_cluster_admin_token.my_token.token

}

output "hcp_vault_cluster_public_ip" {
  value = hcp_vault_cluster.my_cluster.vault_public_endpoint_url
}

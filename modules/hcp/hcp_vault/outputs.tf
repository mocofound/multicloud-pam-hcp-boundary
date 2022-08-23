output "hcp_vault_cluster_admin_token" {
  #sensitive = true
  value = hcp_vault_cluster_admin_token.my_token.token

}

output "hcp_vault_cluster_public_ip" {
  value = hcp_vault_cluster.boundary_vault_cluster.vault_public_endpoint_url
}
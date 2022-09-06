resource "hcp_vault_cluster" "boundary_vault_cluster" {
  cluster_id = "${var.prefix}-vault-cluster"
  #cluster_id = "hcp-tf-boundary-vault-cluster"
  hvn_id = var.hcp_boundary_hvn_id
  tier = var.hcp_vault_tier
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "my_token" {
  cluster_id = hcp_vault_cluster.boundary_vault_cluster.cluster_id
}


output "hvn_id" {
  value = var.hcp_boundary_hvn_id
}
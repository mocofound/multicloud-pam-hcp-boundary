resource "hcp_vault_cluster" "my_cluster" {
  cluster_id = "hcp-tf-boundary-vault-cluster"
  hvn_id = "boundary-hvn"
  public_endpoint = true
}
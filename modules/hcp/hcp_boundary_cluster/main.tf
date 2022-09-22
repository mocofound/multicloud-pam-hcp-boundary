resource "hcp_boundary_cluster" "boundary_cluster" {
  cluster_id = var.cluster_id
  username   = var.username
  password   = var.password
}
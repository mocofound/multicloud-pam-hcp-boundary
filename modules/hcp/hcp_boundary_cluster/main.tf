resource "hcp_boundary_cluster" "boundary_cluster" {
  cluster_id = var.cluster_id
  username   = var.username
  password   = var.password
  tier = "PLUS"

    maintenance_window_config {
    day          = "FRIDAY"
    start        = 2
    end          = 12
    upgrade_type = "SCHEDULED"
  }

}


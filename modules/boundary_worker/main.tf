
hcp_boundary_cluster_id = "<cluster-id>"

listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}

worker {
  public_addr = "107.22.128.152"
  auth_storage_path = "/home/ubuntu/boundary/worker1"
  tags {
    type = ["dev-worker", "ubuntu"]
  }
}

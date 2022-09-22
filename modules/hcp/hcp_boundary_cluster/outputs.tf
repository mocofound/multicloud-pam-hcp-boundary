output "boundary_password_auth_method_id" {
  #value = hcp_boundary_cluster.boundary_cluster.auth_method_id
  value = "fixme"
}

output "boundary_login_name" {
  value = hcp_boundary_cluster.boundary_cluster.username
}

output "boundary_login_password" {
  value = hcp_boundary_cluster.boundary_cluster.password
}

output "boundary_addr" {
  value = hcp_boundary_cluster.boundary_cluster.cluster_url
}
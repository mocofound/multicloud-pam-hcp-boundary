output "boundary_password_auth_method_id" {
  value = data.http.boundary_cluster_auth_methods.response_body
  #value = "fixme"
}

data "http" "boundary_cluster_auth_methods" {
  url = "${hcp_boundary_cluster.boundary_cluster.cluster_url}/v1/auth-methods?filter=%22password%22+in+%22%2Fitem%2Ftype%22&scope_id=global"
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


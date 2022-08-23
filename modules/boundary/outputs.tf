output "boundary_scope_project_aws_id" {
  value = boundary_scope.project_aws.id
}

output "boundary_host_set_static_aws_ssh" {
  value = boundary_host_set_static.aws_ssh.id
}

output "boundary_host_set_static_postgres" {
  value = boundary_host_set_static.postgres.id
}

output "boundary_host_catalog_static_aws_ssh" {
  value = boundary_host_catalog_static.aws_ssh.id
}

output "boundary_host_catalog_static_postgres" {
  value = boundary_host_catalog_static.postgres.id
}


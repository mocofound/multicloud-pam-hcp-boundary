resource "boundary_host_catalog_static" "aws_ssh" {
  name        = "aws_host_catalog"
  description = "test catalog"
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_host_static" "aws_ssh" {
  type            = "static"
  name            = "aws_ec2_ssh_host_1"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  address         = var.aws_ec2_instance
}

resource "boundary_host_set_static" "aws_ssh" {
  type            = "static"
  name            = "aws_host_set"
  description     = "boundary host set static for aws ssh"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id

  host_ids = [
    boundary_host_static.aws_ssh.id,
  ]
}

# resource "boundary_host_catalog_static" "aws_windows_rdp" {
#   name        = "aws_windows_rdp_host_catalog"
#   description = "aws_windows_rdp test catalog"
#   scope_id    = boundary_scope.project_aws.id
# }

resource "boundary_host_static" "aws_windows_rdp" {
  type            = "static"
  name            = "aws_windows_rdp"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  address         = var.aws_ec2_windows_instance
}

resource "boundary_host_set_static" "aws_windows_rdp" {
  #type            = "static"
  name            = "aws_host_set_windows_rdp"
  description     = "boundary host set static for aws windows rdp"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  host_ids = [
    boundary_host_static.aws_windows_rdp.id,
  ]
}

resource "boundary_host_catalog_static" "postgres" {
  name        = "postgres_host_catalog"
  description = "postgres host catalog"
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_host_set_static" "postgres" {
  type            = "static"
  name            = "postgres_host_set"
  host_catalog_id = boundary_host_catalog_static.postgres.id

  host_ids = [
    boundary_host_static.rds_postgres.id,
  ]
}

resource "boundary_host_static" "rds_postgres" {
  type            = "static"
  name            = "postgres_rds_host"
  host_catalog_id = boundary_host_catalog_static.postgres.id
  address         = var.aws_rds_db
}

resource "boundary_host_catalog_static" "azure_ssh" {
  name        = "azure_host_catalog"
  description = "azure ssh test catalog"
  scope_id    = boundary_scope.project_azure.id
}

resource "boundary_host_static" "azure_ssh" {
  type            = "static"
  name            = "azure_vm_ssh_host_1"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id
  address         = var.azure_vm_instance
}


resource "boundary_host_set_static" "azure_ssh" {
  type            = "static"
  name            = "azure_host_set_3"
  description     = "boundary host set static for azure vm ssh"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id

  host_ids = [
    boundary_host_static.azure_ssh.id,
  ]
}

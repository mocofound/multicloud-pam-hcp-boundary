resource "boundary_target" "aws_ssh" {
  name         = "aws_ec2_ssh_target"
  description  = "aws_ec2_ssh_target"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  host_source_ids = [
    boundary_host_set_static.aws_ssh.id,
  ]
  application_credential_source_ids = [
    boundary_credential_library_vault.aws_ssh.id,
  ]
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres_db_target"
  description              = "Backend postgres target"
  scope_id                 = boundary_scope.project_aws.id
  default_port             = 5432
  session_connection_limit = -1
  application_credential_source_ids = [
    boundary_credential_library_vault.postgres_cred_library.id
  ]
  host_source_ids = [
    boundary_host_set_static.postgres.id
  ]
}
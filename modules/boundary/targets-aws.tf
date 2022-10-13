resource "boundary_target" "aws_ssh" {
  name         = "aws_ec2_ssh_target"
  description  = "aws_ec2_ssh_target ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  session_connection_limit = -1
  session_max_seconds      = 1000
  #worker_filter = "\"aws\" in \"/tags/type\""
  host_source_ids = [
    boundary_host_set_static.aws_ssh.id,
  ]
  injected_application_credential_source_ids = [
      boundary_credential_library_vault.aws_ssh.id,
  ]
}

resource "boundary_target" "aws_ssh_2" {
  name         = "aws_ec2_ssh_2_target"
  description  = "aws_ec2_ssh_target ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  session_connection_limit = -1
  session_max_seconds      = 10000
  #worker_filter = "\"aws\" in \"/tags/type\""
  host_source_ids = [
    boundary_host_set_static.aws_ssh.id,
  ]
  # injected_application_credential_source_ids = [
  #     boundary_credential_library_vault.aws_ssh.id,
  # ]
}

resource "boundary_target" "aws_hcp_worker" {
  name         = "aws_ec2_hcp_worker_target"
  description  = "aws_ec2_hcp_worker_target ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  session_connection_limit = -1
  session_max_seconds      = 1000
  host_source_ids = [
    boundary_host_set_static.aws_ssh.id,
  ]
  injected_application_credential_source_ids = [
      boundary_credential_library_vault.aws_ssh.id,
  ]
}

resource "boundary_target" "aws_windows_rdp" {
  name         = "aws_windows_rdp_target"
  description  = "aws_windows_rdp_target rdp target"
  type = "tcp"
  default_port = 3389
  scope_id     = boundary_scope.project_aws.id
  session_connection_limit = -1
  session_max_seconds      = 100000
  host_source_ids = [
    boundary_host_set_static.aws_windows_rdp.id,
  ]
  #worker_filter = "\"aws\" in \"/tags/type\""
  
  # brokered_credential_source_ids = [
  #    boundary_credential_library_vault.aws_windows_rdp.id,
  #  ]
  # injected_application_credential_source_ids = [
  #     boundary_credential_library_vault.aws_ssh.id,
  # ]
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres_db_target"
  description              = "Backend postgres target"
  scope_id                 = boundary_scope.project_aws.id
  default_port             = 5432
  session_connection_limit = -1
  brokered_credential_source_ids = [
    boundary_credential_library_vault.postgres_cred_library.id
  ]
  host_source_ids = [
    boundary_host_set_static.postgres.id
  ]
}
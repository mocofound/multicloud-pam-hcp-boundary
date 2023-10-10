# resource "boundary_account_password" "shawn" {
#   auth_method_id = var.auth_method_id
#   login_name     = "shawn"
#   password       = "hurst$$$$"
# }

# resource "boundary_user" "shawn" {
#   name        = "shawn"
#   description = "Shawn's user resource"
#   account_ids = [boundary_account_password.shawn.id]
#   scope_id    = boundary_scope.global.id

# }

resource "boundary_scope" "project" {
  name                   = "project_one"
  description            = "My first scope!"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

resource "boundary_group" "tde" {
  name        = "TDE"
  description = "TDE"
  member_ids  = []
  #member_ids  = [boundary_user.shawn.id]
  scope_id    = boundary_scope.project_tde.id
}

resource "boundary_role" "boundary_tde_role" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_group.tde.id,boundary_managed_group.idp_aws_users.id]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project_tde.id
}

resource "boundary_host_static" "tde_vault" {
  type            = "static"
  name            = "azure_vault"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id
  address         = "20.163.249.35"
}

resource "boundary_host_static" "tde_sql" {
  type            = "static"
  name            = "azure_sql"
  host_catalog_id = boundary_host_catalog_static.tde.id
  address         = "20.163.249.35"
}

resource "boundary_target" "tde_vault_ssh" {
  name         = "tde_vault_ssh"
  description  = "tde_vault_ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_tde.id
  session_connection_limit = -1
  session_max_seconds      = 1000
  address         = "20.163.249.35"
  #worker_filter = "\"aws\" in \"/tags/type\""
  # host_source_ids = [
  #   boundary_host_static.tde_vault.id,
  # ]
  injected_application_credential_source_ids = [
      boundary_credential_library_vault.tde.id,
  ]
}

resource "boundary_target" "tde_mssql" {
  name         = "tde_mssql_rdp"
  description  = "tde_mssql rdp target"
  type = "tcp"
  default_port = 3389
  scope_id     = boundary_scope.project_tde.id
  session_connection_limit = -1
  session_max_seconds      = 100000
  address         = "20.232.196.181"
  # host_source_ids = [
  #   boundary_host_static.tde_sql.id,
  # ]
  #worker_filter = "\"aws\" in \"/tags/type\""
  
   brokered_credential_source_ids = [
      boundary_credential_library_vault.tde_rdp.id,
    ]
  # injected_application_credential_source_ids = [
  #     boundary_credential_library_vault.aws_ssh.id,
  # ]
}
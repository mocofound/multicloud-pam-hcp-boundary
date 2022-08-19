#The OIDC auth method resource allows you to configure a Boundary auth_method_oidc.
resource "boundary_auth_method_oidc" "auth" {
  scope_id               = boundary_scope.global.id                          #"global"
  name                   = "Azure AD OIDC"
  description            = "OIDC with Azure AD Tenant XYZ"
  issuer                 = "https://sts.windows.net/${var.aad_tenant_id}/"
  client_id              = var.aad_client_id
  client_secret          = var.aad_client_secret_value
  signing_algorithms     = ["RS256"]
  api_url_prefix         = var.boundary_controller_address      #"https://d2060e91-05ee-4e23-bb56-5ada2cbf7628.boundary.hashicorp.cloud"
  is_primary_for_scope   = true
  #state                  = "active-public"
	#callback_url           = "https://72a42559-c184-43ab-ac89-82dc40245e58.boundary.hashicorp.cloud/v1/auth-methods/oidc:authenticate:callback"
}

output "database_connection_string" {
  value = vault_database_secret_backend_connection.postgres.postgresql[0].connection_url
}

output "database_name_from_vault_backend" {
  value = vault_database_secret_backend_connection.postgres.name
}


/*
#Alternatively, set primary auth method for scope so that users are created on the fly
resource "boundary_account_oidc" "oidc_user" {
  name           = "user1"
  description    = "OIDC account for user1"
  auth_method_id = boundary_auth_method_oidc.auth.id
  issuer  = "https://sts.windows.net/${var.aad_tenant_id}/"
  #AAD APP Object ID
  subject = "1052e6ac-3ebd-44f0-8c8d-589a0d008d2a"
}
*/

#Creating Global Scope
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
  description  = "Global Scope"
  name         = "Global"
}

#Create organization scope within global
resource "boundary_scope" "org" {
  name                     = "organization_one"
  description              = "My first organization scope!"
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

#Creating an project scope within an organization:
resource "boundary_scope" "project_aws" {
  name                   = "project_aws"
  description            = "AWS"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
  auto_create_default_role = true
}

#Creating an project scope within an organization:
resource "boundary_scope" "project_azure" {
  name                   = "project_azure"
  description            = "Azure"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
  auto_create_default_role = true
}

#Creating an project scope within an organization:
resource "boundary_scope" "project_gcp" {
  name                   = "project_gcp"
  description            = "GCP"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
  auto_create_default_role = true
}

#Creating an project scope within an organization:
resource "boundary_scope" "project_onprem" {
  name                   = "project_onprem"
  description            = "onprem"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
  auto_create_default_role = true
}

resource "boundary_managed_group" "idp_aws_users" {
  name           = "idp_aws_users"
  description    = "AWS users as defined by external IDP/auth method"

  auth_method_id = boundary_auth_method_oidc.auth.id
  filter         = "\"onmicrosoft.com\" in \"/userinfo/upn\""
}

resource "boundary_role" "oidc_role_1" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_aws_users.id]
  #TODO: Filter type down from * to be more specific
  #  grant_strings = ["id=*;type=*;actions=list,read"]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project_aws.id
}

resource "boundary_role" "oidc_role_100" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_aws_users.id]
  #TODO: Filter type down from * to be more specific
  #  grant_strings = ["id=*;type=*;actions=list,read"]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project_gcp.id
}

/*
resource "boundary_role" "oidc_role_2" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_aws_users.id]
  #TODO: Filter type down from * to be more specific
  #  grant_strings = ["id=*;type=*;actions=list,read"]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.org.id
  #grant_scope_id = boundary_scope.global.scope_id
}


resource "boundary_role" "oidc_role_3" {
  name          = "List and Read global"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_aws_users.id]
  #TODO: Filter type down from * to be more specific
  #  grant_strings = ["id=*;type=*;actions=list,read"]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.global.id
}
*/

resource "boundary_host_catalog_static" "foo" {
  name        = "aws_host_catalog"
  description = "test catalog"
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_host_static" "foo" {
  type            = "static"
  name            = "awsec2_ssh_host_1"
  host_catalog_id = boundary_host_catalog_static.foo.id
  address         = aws_instance.hashicat.public_ip
}

resource "boundary_host_set_static" "foo" {
  type            = "static"
  name            = "aws_host_set"
  host_catalog_id = boundary_host_catalog_static.foo.id

  host_ids = [
    boundary_host_static.foo.id,
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
    boundary_host_static.postgres.id,
  ]
}

resource "boundary_host_static" "postgres" {
  type            = "static"
  name            = "postgres_host_1"
  host_catalog_id = boundary_host_catalog_static.postgres.id
  address         = aws_db_instance.rds.address
}

resource "boundary_host_static" "rds_postgres" {
  type            = "static"
  name            = "postgres_rds_host"
  host_catalog_id = boundary_host_catalog_static.postgres.id
  address         = aws_db_instance.rds.address
}

/*
resource "boundary_credential_store_static" "creds" {
  name        = "example_static_credential_store"
  description = "My first static credential store!"
  scope_id    = boundary_scope.project_aws.id
}
*/


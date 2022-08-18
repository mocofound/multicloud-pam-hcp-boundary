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
  name        = "test"
  description = "test catalog"
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_host_static" "foo" {
  type            = "static"
  name            = "aws_host_1"
  host_catalog_id = boundary_host_catalog_static.foo.id
  address         = aws_instance.hashicat.public_ip
}

resource "boundary_host_static" "bar" {
  type            = "static"
  name            = "aws_host_2"
  host_catalog_id = boundary_host_catalog_static.foo.id
  address         = aws_instance.hashicat.public_ip
}

resource "boundary_host_set_static" "foo" {
  type            = "static"
  name            = "foo"
  host_catalog_id = boundary_host_catalog_static.foo.id

  host_ids = [
    boundary_host_static.foo.id,
    boundary_host_static.bar.id,
  ]
}

resource "boundary_target" "foo" {
  name         = "aws_target_1"
  description  = "aws_target_1"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  host_source_ids = [
    boundary_host_set_static.foo.id
  ]
  application_credential_source_ids = [
    boundary_credential_library_vault.aws_ssh.id
  ]
}

resource "boundary_credential_store_static" "creds" {
  name        = "example_static_credential_store"
  description = "My first static credential store!"
  scope_id    = boundary_scope.project_aws.id
}

/*
resource "boundary_group" "aws_users" {
  name        = "aws_users"
  description = "aws_users"
  member_ids  = ["u_mhjU1BIExy"]
  scope_id    = boundary_scope.org.id
}

resource "boundary_group" "azure_users" {
  name        = "azure users"
  description = "azure users"
  member_ids  = ["u_auth"]
  scope_id    = boundary_scope.org.id
}

resource "boundary_group" "gcp_users" {
  name        = "gcp users"
  description = "gcp users"
  member_ids  = ["u_nzuKzWnkQU"]
  scope_id    = boundary_scope.org.id
}

resource "boundary_group" "onprem_users" {
  name        = "onprem users"
  description = "onprem users"
  member_ids  = ["u_nzuKzWnkQU"]
  scope_id    = boundary_scope.org.id
}
*/

resource "boundary_credential_library_vault" "aws_ssh" {
  name                = "aws_ssh"
  description         = "My first Vault credential library!"
  credential_store_id = boundary_credential_store_vault.my_cred_store.id
  path                = "kv/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  
}


resource "boundary_credential_store_vault" "my_cred_store" {
  name        = "my_cred_store"
  description = "My first Vault credential store!"
  address     = hcp_vault_cluster.my_cluster.vault_public_endpoint_url     # change to Vault address
  namespace   = "admin"
  token       = vault_token.boundary_token.client_token               # change to valid Vault token
  scope_id    = boundary_scope.project_aws.id
}

/*
resource "boundary_host_catalog_static" "aws_static" {
  scope_id = boundary_scope.project_aws.id
}

resource "boundary_host_static" "first" {
  type            = "static"
  name            = "aws_host_1"
  description     = "My first aws host!"
  address         = aws_instance.hashicat.public_dns
  host_catalog_id = boundary_host_catalog_static.aws_static.id

  depends_on = [
    aws_instance.hashicat
  ]
}
*/

/*
resource "boundary_role" "scope_admin" {
  scope_id       = boundary_scope.org.id
  grant_scope_id = "global"
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = []
}


resource "boundary_credential_store_vault" "my_store" {
  name        = "foo"
  description = "My first Vault credential store!"
  address     = hcp_vault_cluster.my_cluster.vault_public_endpoint_url     # change to Vault address
  namespace   = "admin"
  token       = hcp_vault_cluster_admin_token.my_token.token               # change to valid Vault token
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_credential_library_vault" "foo" {
  name                = "foo"
  description         = "My first Vault credential library!"
  credential_store_id = boundary_credential_store_vault.my_store.id
  path                = "kv/foo" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "bar" {
  name                = "bar"
  description         = "My second Vault credential library!"
  credential_store_id = boundary_credential_store_vault.my_store.id
  path                = "kv/bar" # change to Vault backend path
  http_method         = "POST"
  http_request_body   = <<EOT
{
  "key": "Value",
}
EOT
}
*/
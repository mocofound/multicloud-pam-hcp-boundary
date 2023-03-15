#The OIDC auth method resource allows you to configure a Boundary auth_method_oidc.

resource "boundary_auth_method_oidc" "auth" {
  scope_id               = boundary_scope.global.id                          #"global"
  name                   = "Azure AD OIDC"
  description            = "OIDC with Azure AD Tenant XYZ"
  issuer                 = "https://sts.windows.net/${var.aad_tenant_id}/"
  client_id              = var.aad_client_id
  client_secret          = var.aad_client_secret_value
  signing_algorithms     = ["RS256"]
  #api_url_prefix         = var.boundary_controller_address     
  api_url_prefix =  var.boundary_controller_address
  is_primary_for_scope   = true
 }

 resource "boundary_managed_group" "idp_aws_users" {
  name           = "idp_aws_users"
  description    = "AWS users as defined by external IDP/auth method"

  auth_method_id = boundary_auth_method_oidc.auth.id
  filter         = "\"9e587b96-d37a-44a9-b862-4868f6deebc7\" in \"/token/groups\""
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


resource "boundary_managed_group" "idp_gcp_users" {
  name           = "idp_gcp_users"
  description    = "GCP users as defined by external IDP/auth method"
  auth_method_id = boundary_auth_method_oidc.auth.id
  #Below uses AAD groupid, which could be a module output from AAD/oidc module
  filter         = "\"89fa53c6-bdcb-4dd1-8ada-0387296f9918\" in \"/token/groups\""
}

resource "boundary_managed_group" "idp_azure_users" {
  name           = "idp_azure_users"
  description    = "Azure users as defined by external IDP/auth method"
  auth_method_id = boundary_auth_method_oidc.auth.id
  #Below uses AAD groupid, which could be a module output from AAD/oidc module
  filter         = "\"c07786ab-4b7e-4078-a393-9b3be91df830\" in \"/token/groups\""
}


resource "boundary_role" "oidc_role_100" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_gcp_users.id]
  #TODO: Filter type down from * to be more specific
  #  grant_strings = ["id=*;type=*;actions=list,read"]
  grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project_gcp.id
}

resource "boundary_role" "boundary_azure_role" {
  name          = "List and Read"
  description   = "List and read role"
  principal_ids = [boundary_managed_group.idp_azure_users.id]
    grant_strings = ["id=*;type=*;actions=*"]
  scope_id      = boundary_scope.project_azure.id
}
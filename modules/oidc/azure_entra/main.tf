# Retrieve connection context so we can programmatically discover tenant_id later.
data "azuread_client_config" "this" {}

## Random naming function for the Enterprise App
resource "random_pet" "this" {
  length = 2
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

## Create the AzureAD App Registration used by OIDC
// Discover the Microsoft Graph service principal so we can pass it to our App Registration.
data "azuread_service_principal" "ms_graph" {
  display_name = "Microsoft Graph"
}

resource "random_uuid" "this" {
	for_each = { for v in var.user_assignment: v.group_name => v}
}

resource "azuread_application" "this" {
  display_name            = var.azuread_application_display_name != "" ? var.azuread_application_display_name : "${random_pet.this.id}-${random_integer.this.result}"
  group_membership_claims = var.group_membership_claims

	dynamic app_role {
		for_each = { for v in var.user_assignment: v.group_name => v }
		content {
			allowed_member_types = ["User"]
			description          = "Application access for ${app_role.value.group_name}"
			display_name         = app_role.value.group_name
			enabled              = "true"
			value                = app_role.value.group_name
			id									 = random_uuid.this[app_role.value.group_name].result
		}
	}

  web {
    redirect_uris = var.redirect_uris
    homepage_url  = var.homepage_url != "" ? var.homepage_url : null
    logout_url    = var.logout_url != "" ? var.logout_url : null
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }
  # Assign GroupMember.Read.All permissions to the Microsoft Graph
  # per https://www.vaultproject.io/docs/auth/jwt_oidc_providers#azure-active-directory-aad
  required_resource_access {
    resource_app_id = data.azuread_service_principal.ms_graph.application_id
    dynamic "resource_access" {
      for_each = toset(var.app_resource_permissions)
      content {
        type = "Scope"
        id   = [for app_role in data.azuread_service_principal.ms_graph.oauth2_permission_scopes : app_role.id if app_role.value == resource_access.value][0]
      }
    }
  }
}

resource "azuread_application_federated_identity_credential" "this" {
  application_object_id = azuread_application.this.object_id
  display_name          = var.federated_identity_credentials.display_name
  description           = var.federated_identity_credentials.description
  audiences             = var.federated_identity_credentials.audiences
  issuer                = var.federated_identity_credentials.issuer
  subject               = var.federated_identity_credentials.subject
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

resource "time_rotating" "this" {
  rotation_days = 7
}

resource "azuread_application_password" "this" {
  application_object_id = azuread_application.this.id
	end_date_relative = "720h"
  # keepers = {
  #   rotation = time_rotating.this.id
  # }
}

resource "azuread_app_role_assignment" "this" {
	for_each = { for v in azuread_application.this.app_role: v.value => v }
	resource_object_id = azuread_service_principal.this.object_id
	principal_object_id = azuread_group.this[each.value.display_name].object_id
	app_role_id = azuread_application.this.app_role_ids[each.value.value]
}

resource "azuread_group" "this" {
	for_each = { for v in var.user_assignment: v.group_name => v }
	display_name = each.value.group_name
	security_enabled = true
	members = data.azuread_users.this[each.value.group_name].object_ids
}

data "azuread_users" "this" {
	for_each = { for v in var.user_assignment: v.group_name => v }
	mail_nicknames = each.value.members
}

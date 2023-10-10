output "azuread_application_name" {
  value = azuread_application.this.display_name
}

output "application_client_id" {
  value = azuread_application.this.application_id
}

output "azuread_application_password" {
  value = azuread_application_password.this.value
}

output "service_principal_object_id" {
  value = azuread_service_principal.this.object_id
}

output "azuread_tenant_id" {
  value = data.azuread_client_config.this.tenant_id
}

output "oidc_discovery_url" {
  value = "https://login.microsoftonline.com/${data.azuread_client_config.this.tenant_id}/v2.0"
}

# output "azuread_subscription_id" {
# 	value = data.azuread_client_config.this.subsciption_id
# }


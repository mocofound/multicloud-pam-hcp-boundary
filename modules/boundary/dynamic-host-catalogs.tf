# Grab some information about and from the current AWS account.
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "demo_user_permissions_boundary" {
  name = "DemoUser"
}

locals {
  my_email = split("/", data.aws_caller_identity.current.arn)[2]
}

# Generate some secrets to pass in to the Boundary configuration.
# WARNING: These secrets are not encrypted in the state file. Ensure that you do not commit your state file!
resource "aws_iam_access_key" "boundary_dynamic_host_catalog" {
  user = aws_iam_user.boundary_dynamic_host_catalog.name
  lifecycle {
    ignore_changes = [
      user
    ]
  }
}

# Create the user to be used in Boundary for dynamic host discovery. Then attach the policy to the user.
resource "aws_iam_user" "boundary_dynamic_host_catalog" {
  name                 = "demo-${local.my_email}-bdhc"
  permissions_boundary = data.aws_iam_policy.demo_user_permissions_boundary.arn
  force_destroy        = true
}

resource "aws_iam_user_policy_attachment" "boundary_dynamic_host_catalog" {
  user   = aws_iam_user.boundary_dynamic_host_catalog.name
  policy_arn = data.aws_iam_policy.demo_user_permissions_boundary.arn
  #name   = "DemoUserInlinePolicy"
  lifecycle {
    ignore_changes = all
    
  }
}


output "boundary_dynamic_host_catalog_aws_iam_access_key_secret" {
  value = aws_iam_access_key.boundary_dynamic_host_catalog.secret
}
output "boundary_dynamic_host_catalog_aws_iam_access_key_id" {
  value = aws_iam_access_key.boundary_dynamic_host_catalog.id
}
output "boundary_dynamic_host_catalog_aws_iam_access_key_user" {
  value = aws_iam_access_key.boundary_dynamic_host_catalog.user
}

resource "boundary_host_catalog_plugin" "aws_ssh" {
  name            = "AWS Dynamic Hosts Catalog"
  description     = "Lookups for EC2 instances with specified tag"
  scope_id        = boundary_scope.project_aws.id
  plugin_name     = "aws"
  attributes_json = jsonencode({ 
  "region" = "us-west-2",
  "disable_credential_rotation" = false
   })

#    1) Uncomment the below secrets_json
#    2) terraform taint "module.boundary.boundary_host_catalog_plugin.aws_ssh"
#    3) terraform apply --auto-approve
#    4) Recomment out secrets_json
#
#     secrets_json = jsonencode({
#     "access_key_id"     = aws_iam_access_key.boundary_dynamic_host_catalog.id
#     "secret_access_key" = aws_iam_access_key.boundary_dynamic_host_catalog.secret
#  })

# Don't use this here it is just for historical info
#     secrets_json = jsonencode({
#     "access_key_id"     = "AKIA3PL2TGEMSY7f5AR"
#     "secret_access_key" = "cKsh/CNFJvjFl/benhwN4fbZfP+4YrwdyRJMwMF"
#   })
  depends_on = [
    aws_iam_access_key.boundary_dynamic_host_catalog
  ]
  
}

resource "boundary_host_set_plugin" "aws_nomad_servers" {
  name                = "nomad_servers"
  description = "nomad_servers"
  host_catalog_id     = boundary_host_catalog_plugin.aws_ssh.id
  preferred_endpoints = ["cidr:54.0.0.0/8","cidr:35.0.0.0/8","cidr:52.0.0.0/8",]
  attributes_json = jsonencode({
    "filters" = "tag:boundary=ssh",
    "filters" = "tag:NomadType=server",
  })
  sync_interval_seconds = 60
}

resource "boundary_host_set_plugin" "aws_nomad_clients" {
  name                = "nomad_clients"
  description = "nomad_clients"
  host_catalog_id     = boundary_host_catalog_plugin.aws_ssh.id
  preferred_endpoints = ["cidr:172.0.0.0/8"]
  attributes_json = jsonencode({
    "filters" = "tag:boundary=ssh",
    "filters" = "tag:NomadType=client",
  })
  sync_interval_seconds = 60
}

resource "boundary_host_set_plugin" "aws_vault_servers" {
  name                = "vault_asg_servers"
  description = "vault_servers"
  host_catalog_id     = boundary_host_catalog_plugin.aws_ssh.id
  preferred_endpoints = ["cidr:54.0.0.0/8","cidr:35.0.0.0/8","cidr:52.0.0.0/8",]
  attributes_json = jsonencode({
    "filters" = "tag:boundary=sa",
    "filters" = "tag:VaultType=server",
  })
  sync_interval_seconds = 60
}

# # For more information about the azure plugin, please visit here:
# # https://github.com/hashicorp/boundary-plugin-host-azure
# #
# # For more information about azure ad applications, please visit here:
# # https://learn.hashicorp.com/tutorials/boundary/azure-host-catalogs#register-a-new-azure-ad-application-1
# resource "boundary_host_catalog_plugin" "azure_example" {
#   name        = "My azure catalog"
#   description = "My second host catalog!"
#   scope_id    = boundary_scope.project.id
#   plugin_name = "azure"

#   # the attributes below must be generated in azure by creating an ad application
#   attributes_json = jsonencode({
#     "disable_credential_rotation" = "true",
#     "tenant_id"                   = "ARM_TENANT_ID",
#     "subscription_id"             = "ARM_SUBSCRIPTION_ID",
#     "client_id"                   = "ARM_CLIENT_ID"
#   })

#   # recommended to pass in aws secrets using a file() or using environment variables
#   # the secrets below must be generated in azure by creating an ad application
#   secrets_json = jsonencode({
#     "secret_value" = "ARM_CLIENT_SECRET"
#   })
# }



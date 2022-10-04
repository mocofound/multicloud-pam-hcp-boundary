
variable "child_namespaces" {
  default = [
    "prod",
    "nonprod",
  ]
}

locals {
  child_namespaces = toset(var.child_namespaces)
}

resource "vault_namespace" "aws" {
  path = "parent"
}

resource "vault_namespace" "children" {
  for_each  = local.child_namespaces
  namespace = vault_namespace.aws.path
  path      = each.key
}

resource "vault_mount" "children" {
  for_each  = local.child_namespaces
  namespace = vault_namespace.children[each.key].path_fq
  path      = "secrets"
  type      = "kv"
  options = {
    version = "2"
  }
}

resource "vault_generic_secret" "children" {
  for_each  = local.child_namespaces
  namespace = vault_mount.children[each.key].namespace
  path      = "${vault_mount.children[each.key].path}/secret"
  data_json = jsonencode(
    {
      "ns" = each.key
    }
  )
}

# resource "vault_namespace" "aws" {
  
# }

# resource "vault_mount" "aws-kvv2-prod" {
#   namespace = vault_namespace.aws.path_fq
#   path      = "prod" // Having 2 different vault mount resources.
#   type      = "kv"
#   options = {
#     version = "2"
#   }
# }

# resource "vault_mount" "aws-kvv2-nonprod" {
#   namespace = vault_namespace.aws.path_fq
#   path      = "non-prod" 
#   type      = "kv"
#   options = {
#     version = "2"
#   }
# }

# resource "vault_generic_secret" "example" {
#   namespace = vault_mount.aws-kvv2.namespace
#   path      = "${vault_mount.aws.path}/secret" // Can we create an even deeper nested path this way?   
#   data_json = jsonencode(
#     {
#     # empty
#     }
#   )
#   Lifecycle {
#      ignore_changes = [data_json,]
# }
# }
#Creating Global Scope
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
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
resource "boundary_scope" "project" {
  name                   = "project_one"
  description            = "My first project scope!"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

#The OIDC auth method resource allows you to configure a Boundary auth_method_oidc.
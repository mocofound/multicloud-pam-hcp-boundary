

#Creating Global Scope
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
  description  = "Global Scope"
  name         = "global"
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

#Creating an project scope within an organization:
resource "boundary_scope" "project_tde" {
  name                   = "project_tde"
  description            = "tde"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
  auto_create_default_role = true
}
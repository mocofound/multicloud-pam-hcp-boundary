
resource "boundary_host_catalog_static" "aws_ssh" {
  name        = "aws_host_catalog"
  description = "test catalog"
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_host_catalog_static" "postgres" {
  name        = "postgres_host_catalog"
  description = "postgres host catalog"
  scope_id    = boundary_scope.project_aws.id
}


resource "boundary_host_catalog_static" "azure_ssh" {
  name        = "azure_host_catalog"
  description = "azure ssh test catalog"
  scope_id    = boundary_scope.project_azure.id
}

# resource "boundary_host_catalog_static" "aws_windows_rdp" {
#   name        = "aws_windows_rdp_host_catalog"
#   description = "aws_windows_rdp test catalog"
#   scope_id    = boundary_scope.project_aws.id
# }

resource "boundary_host_catalog_static" "azure_aks" {
  name        = "azure_aks_host_catalog"
  description = "azure aks host catalog"
  scope_id    = boundary_scope.project_azure.id
}
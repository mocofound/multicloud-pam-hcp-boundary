resource "boundary_host_set_static" "aws_ssh" {
  type            = "static"
  name            = "aws_host_set"
  description     = "boundary host set static for aws ssh"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id

  host_ids = [
    boundary_host_static.aws_ssh.id,
  ]
}

resource "boundary_host_set_static" "aws_windows_rdp" {
  #type            = "static"
  name            = "aws_host_set_windows_rdp"
  description     = "boundary host set static for aws windows rdp"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  host_ids = [
    boundary_host_static.aws_windows_rdp.id,
  ]
}

resource "boundary_host_set_static" "postgres" {
  type            = "static"
  name            = "postgres_host_set"
  host_catalog_id = boundary_host_catalog_static.postgres.id

  host_ids = [
    boundary_host_static.rds_postgres.id,
  ]
}

resource "boundary_host_set_static" "azure_ssh" {
  type            = "static"
  name            = "azure_host_set_3"
  description     = "boundary host set static for azure vm ssh"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id

  host_ids = [
    boundary_host_static.azure_ssh.id,
  ]
}

resource "boundary_host_set_static" "azure_vm_ssh_hcp_worker" {
  type            = "static"
  name            = "azure_host_set_4"
  description     = "boundary host set static for azure vm ssh hcp worker"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id

  host_ids = [
    boundary_host_static.azure_vm_ssh_hcp_worker.id,
  ]
}

resource "boundary_host_set_static" "azure_aks" {
  type            = "static"
  name            = "azure_aks_host_set_2"
  description     = "boundary host set static for  azure_aks_host_set_2"
  host_catalog_id = boundary_host_catalog_static.azure_aks.id

   host_ids = [
     boundary_host_static.aks_host.id,
   ]
  depends_on = [
    boundary_host_static.aks_host,
  ]
}

resource "boundary_host_set_static" "azure_windows_rdp" {
  type            = "static"
  name            = "azure_windows_rdp"
  description     = "boundary host set static for azure_windows_rdp"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id

  host_ids = [
     boundary_host_static.azure_windows_rdp.id,
   ]
  depends_on = [
    boundary_host_static.azure_windows_rdp,
 
 
 resource "boundary_host_set_static" "azure_windows_rdp" {
  type            = "static"
  name            = "azure_windows_rdp"
  description     = "boundary host set static for azure_windows_rdp"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id

  host_ids = [
     boundary_host_static.azure_windows_rdp.id,
   ]
  depends_on = [
    boundary_host_static.azure_windows_rdp,
  ]
} ]
}

resource "boundary_host_static" "aws_ssh" {
  type            = "static"
  name            = "aws_ec2_ssh_host_1"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  address         = var.aws_ec2_instance
}

resource "boundary_host_static" "aws_windows_rdp" {
  type            = "static"
  name            = "aws_windows_rdp"
  host_catalog_id = boundary_host_catalog_static.aws_ssh.id
  address         = var.aws_ec2_windows_instance
}

resource "boundary_host_static" "azure_vm_ssh_hcp_worker" {
  type            = "static"
  name            = "azure_vm_ssh_hcp_worker"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id
  address         = var.azure_vm_hcp_worker_instance
}

resource "boundary_host_static" "azure_ssh" {
  type            = "static"
  name            = "azure_vm_ssh_host_1"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id
  address         = var.azure_vm_instance
}

resource "boundary_host_static" "rds_postgres" {
  type            = "static"
  name            = "postgres_rds_host"
  host_catalog_id = boundary_host_catalog_static.postgres.id
  address         = var.aws_rds_db
}

resource "boundary_host_static" "aks_host" {
  type            = "static"
  name            = "aks_host"
  host_catalog_id = boundary_host_catalog_static.azure_aks.id
  address         = var.aks_cluster_address

  depends_on = [
    boundary_host_catalog_static.azure_aks,
  ]
}

resource "boundary_host_static" "azure_windows_rdp" {
  type            = "static"
  name            = "aks_host"
  host_catalog_id = boundary_host_catalog_static.azure_ssh.id
  address         = var.azure_windows_rdp_address

  depends_on = [
    boundary_host_catalog_static.azure_ssh,
  ]
}
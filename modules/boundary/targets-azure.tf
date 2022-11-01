resource "boundary_target" "azure_vm_ssh_target" {
  name         = "azure_vm_ssh_target"
  description  = "azure_vm_ssh_target ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_azure.id
  session_connection_limit = -1
  session_max_seconds      = 1000
  worker_filter = "\"azure\" in \"/tags/type\""
  host_source_ids = [
    boundary_host_set_static.azure_ssh.id,
  ]
  injected_application_credential_source_ids = [
      boundary_credential_library_vault.azure_ssh.id,
  ]
}

resource "boundary_target" "azure_hcp_worker" {
  name         = "azure_vm_hcp_worker_target"
  description  = "azure_vm_hcp_worker_target ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project_azure.id
  #worker_filter = "\"azure\" in \"/tags/type\""
  session_connection_limit = -1
  session_max_seconds      = 1000
  host_source_ids = [
    boundary_host_set_static.azure_vm_ssh_hcp_worker.id,
  ]
  injected_application_credential_source_ids = [
      boundary_credential_library_vault.azure_ssh.id,
  ] 
}

resource "boundary_target" "azure_aks_target" {
  name         = "azure_aks_target"
  description  = "azure_aks_target target"
  type         = "tcp"
  default_port = "443"
  worker_filter = "\"azure\" in \"/tags/type\""
  #worker_filter = "\"doesnotexist\" in \"/tags/type\""
  scope_id     = boundary_scope.project_azure.id
  session_connection_limit = -1
  session_max_seconds      = 1000
  host_source_ids = [
    boundary_host_set_static.azure_aks.id,
  ]

  # injected_application_credential_source_ids = [
  #     boundary_credential_library_vault.azure_ssh.id,
  # ] 
}




resource "boundary_target" "azure_windows_rdp" {
  name         = "azure_windows_rdp_target"
  description  = "azure_windows_rdp_target rdp target"
  type = "tcp"
  default_port = 3389
  worker_filter = "\"azure\" in \"/tags/type\""
  scope_id     = boundary_scope.project_azure.id
  session_connection_limit = -1
  session_max_seconds      = 100000
  host_source_ids = [
    boundary_host_set_static.azure_windows_rdp.id,
  ]
  brokered_credential_source_ids = [
     boundary_credential_library_vault.azure_windows_rdp_v1.id,
   ]
  # injected_application_credential_source_ids = [
  #     boundary_credential_library_vault.azure_ssh.id,
  # ]
}
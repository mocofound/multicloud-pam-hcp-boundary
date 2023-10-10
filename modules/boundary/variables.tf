variable "boundary_login_name" {
  default = "changeme"
}

variable "boundary_login_password" {
  default = "changeme"
}

variable "boundary_controller_address" {
  default = "changeme"
}

variable "boundary_password_auth_method_id" {
  default = "changeme"
}
variable "aad_client_id" {
  default = "changeme"
}

variable "aad_client_secret_value" {
  default = "changeme"
}

variable "aad_tenant_id" {
  default = "changeme"
}

variable "vault_address" {
  default = "changeme"
}

variable "vault_token" {
  default = "changeme"
}

variable "vault_namespace" {
  default = "vault_namespace"
}

variable "periodic_no_parent_renewable_vault_token" {
  default = "boundary_token"
}

variable "periodic_no_parent_renewable_vault_token_azure" {
  default = "boundary_token_azure"
}

variable "aws_ec2_instance" {
  default = "changeme"
}

variable "aws_ec2_windows_instance" {
  default = "changeme"
}

variable "aws_rds_db" {
  default = "changeme"
}

variable "azure_vm_instance" {
  default = "changeme"
}

variable "azure_vm_hcp_worker_instance" {
  default = "changeme"
}

variable "aks_cluster_address" {
  default = "changeme"
}

variable "credential_store_description" {
    default = "boundary_cred_store_2"
}

variable "boundary_scope_id" {
    default = "changeme"
}
variable "azure_windows_rdp_address" {
  default = "changeme"
}
#     "access_key_id"     = var.aws_access_key_id
#     "secret_access_key" = var.aws_secret_access_key

variable "aws_access_key_id" {
  default = "set TF_VAR_aws_access_key_id environment variable"
}

variable "aws_secret_access_key" {
  default = "set TF_VAR_aws_secret_access_key environment variable"
}

variable "aws_session_token" {
  default = "set TF_VAR_aws_session_token environment variable"
}

variable "auth_method_id" {
  type = string
  default = ""
}

variable "periodic_no_parent_renewable_vault_token_tde" {
  type = string
}

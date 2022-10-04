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

variable "credential_store_description" {
    default = "boundary_cred_store_2"
}

variable "boundary_scope_id" {
    default = "changeme"
}
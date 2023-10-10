
variable "prefix" {
  default = "changeme"
}

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

variable "hcp_client_id" {
  default = "changeme"
}

variable "hcp_client_secret" {
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

variable "region" {
  description = "The region where the resources are created."
  default     = "us-east-1"
}

variable "vault_namespace" {
  default = "admin"
}

variable "hcp_vault_tier" {
  default = "development"
}

variable "aws_db_instance_login_name" {
  default = "changeme"
}

variable "aws_db_instance_login_password" {
  default = "changeme"
}

variable "gcp_region" {
  default = "changeme"
}

variable "gcp_project_id" {
  default = "changeme"
}

variable "gke_username" {
  default = "changeme"
}

variable "gke_password" {
  default = "changeme"
}

variable "azure_region" {
  default = "us-central1"
}

variable "azure_resource_group_name" {
  default = "changeme"
}

variable "aws_access_key_id" {
  default = "set TF_VAR_aws_access_key_id environment variable"
}

variable "aws_secret_access_key" {
  default = "set TF_VAR_aws_secret_access_key environment variable"
}

variable "aws_session_token" {
  default = "set TF_VAR_aws_session_token environment variable"
}

variable "key_name" {
  type = string
}

variable "initial_upstreams" {
  default = ["db50eb6a-848c-4300-d908-62dc1d7119db.proxy.boundary.hashicorp.cloud:9202","e4a10e80-e73c-cb96-7d39-8652b7f7d186.proxy.boundary.hashicorp.cloud:9202","10f8794a-237a-b459-9fdd-a44a370a9f20.proxy.boundary.hashicorp.cloud:9202"]
}
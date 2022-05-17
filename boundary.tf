provider "boundary" {
  addr                            = "https://8381b284-b0ad-4d8a-82e6-702c4f1fd3c6.boundary.hashicorp.cloud:9200"
  auth_method_id                  = "ampw_VMOMzXwOyJ"
  password_auth_method_login_name = var.login_name        
  password_auth_method_password   = var.login_password
}

variable "login_name" {
  default = "changeme"
}

variable "login_password" {
  default = "changeme"
}

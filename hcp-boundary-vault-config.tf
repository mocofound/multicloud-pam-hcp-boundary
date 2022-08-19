resource "vault_token_auth_backend_role" "boundary_role" {
  role_name              = "boundary_role"
  allowed_policies       = [vault_policy.controller.name, vault_policy.broker.name]
  disallowed_policies    = ["default"]
  allowed_entity_aliases = []
  orphan                 = true
  token_period           = "86400"
  renewable              = true
  token_explicit_max_ttl = "115200"
  path_suffix            = "path-suffix"
}

resource "vault_token" "boundary_token" {
  role_name = "boundary_role"
  renewable = true
  period = "30d"
  namespace = "admin"
  no_default_policy = true
  #no_parent = true
  policies = [vault_policy.controller.name, vault_policy.broker.name]
  #policies = []
  ttl = "25h"
  

  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "boundary-service-account"
  }
  depends_on = [
    vault_token_auth_backend_role.boundary_role
  ]
}
output "vault_token_boundary" {
  sensitive = true
  value = vault_token.boundary_token
}
resource "vault_policy" "controller" {
  name = "boundary-controller-policy"

  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_policy" "broker" {
  name = "boundary-vault-broker-policy"

  policy = <<EOT
path "secret/data/my-secret" {
  capabilities = ["read"]
}

path "secret/data/my-app-secret" {
  capabilities = ["read"]
}

path "postgres/creds/postgres_db_role" {
  capabilities = ["read"]
}

path "*" {
  capabilities = ["read"]
}

EOT
}

resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  namespace     = "admin"
  backend       = vault_mount.db.path
  name          = "postgres"
  verify_connection = false
  allowed_roles = ["postgres_db_role"]
  #maybe /database should be /${aws_db_instance.rds.db_name?}
  postgresql {
    connection_url = "postgres://${var.aws_db_instance_login_name}:${var.aws_db_instance_login_password}@${aws_db_instance.rds.address}:5432/${aws_db_instance.rds.db_name}?sslmode=disable"
  }
  #postgresql {
  #  connection_url = "postgres://postgres:password@${aws_instance.hashicat.public_dns}:5432/database?sslmode=disable"
  #}
  depends_on = [
    aws_db_instance.rds
  ]
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.db.path
  name                = "postgres_db_role"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
  namespace="admin"
}

resource "boundary_target" "foo" {
  name         = "aws_ec2_ssh_target"
  description  = "aws_ec2_ssh_target"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project_aws.id
  host_source_ids = [
    boundary_host_set_static.foo.id
  ]

  #Note: credential type parameter is not available as of v1.0.10 of the Boundary Terraform Provider
  #Use CLI create credential-library with flag -credential-type=ssh_private_key
  #boundary credential-libraries create vault -credential-store-id csvlt_DlGIWbswKx -vault-path "kv/data/my-secret" -credential-type=ssh_private_key
  #Then, manually update application_credential_source_ids to include credentiallibraryid
  application_credential_source_ids = [
    "clvlt_3QoMhzcgfw",
    boundary_credential_library_vault.aws_ssh.id,
  ]
  
}

resource "boundary_target" "postgres" {
  type                     = "tcp"
  name                     = "postgres_db_target"
  description              = "Backend postgres target"
  scope_id                 = boundary_scope.project_aws.id
  default_port             = 5432
  session_connection_limit = -1
  application_credential_source_ids = [
    boundary_credential_library_vault.postgres_cred_library.id
  ]
  host_source_ids = [
    boundary_host_set_static.postgres.id,
  ]
}

resource "boundary_credential_store_vault" "my_cred_store" {
  name        = "my_cred_store"
  description = "My first Vault credential store!"
  address     = hcp_vault_cluster.my_cluster.vault_public_endpoint_url     # change to Vault address
  namespace   = "admin"
  token       = vault_token.boundary_token.client_token               # change to valid Vault token
  scope_id    = boundary_scope.project_aws.id
}

resource "boundary_credential_library_vault" "postgres_cred_library" {
  name                = "postgres_cred_library"
  description         = "Vault credential library for postgres access"
  credential_store_id = boundary_credential_store_vault.my_cred_store.id
  path                = "postgres/creds/postgres_db_role" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "aws_ssh" {
  name                = "aws_ssh"
  description         = "Vault credential library for AWS ssh access"
  credential_store_id = boundary_credential_store_vault.my_cred_store.id
  path                = "kv/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  #Note: credential type parameter is not available as of v1.0.10 of the Boundary Terraform Provider
  #Use CLI create credential-library with flag -credential-type=ssh_private_key
  #boundary credential-libraries create vault -credential-store-id csvlt_DlGIWbswKx -vault-path "kv/data/my-secret" -credential-type=ssh_private_key

  #credential_type     = "ssh_private_key"
  
}

resource "vault_mount" "kv2" {
  path        = "kv"
  type        = "kv-v2"
  description = "kv-v2 secret engine"
}

resource "vault_generic_secret" "ssh_key" {
  path = "kv/my-secret"
  namespace = "admin"
  data_json = jsonencode({
  "username": "ubuntu",
  "private_key": "${tls_private_key.hashicat.private_key_pem}"
})
}
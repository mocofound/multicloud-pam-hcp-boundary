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
  #no_parent = true
  #namespace = "var.vault_namespace"
  no_default_policy = true
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
  capabilities = ["update","read"]
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
  #namespace     = var.vault_namespace
  backend       = vault_mount.db.path
  name          = "postgres"
  verify_connection = false
  allowed_roles = ["postgres_db_role"]
  #maybe /database should be /${aws_db_instance.rds.db_name?}
  postgresql {
    connection_url = "postgres://${var.aws_db_instance_login_name}:${var.aws_db_instance_login_password}@${var.boundary_aws_targets.rds_db_address}:5432/${var.boundary_aws_targets.rds_db_name}?sslmode=disable"
  }
  #postgresql {
  #  connection_url = "postgres://postgres:password@${aws_instance.boundary_poc.public_dns}:5432/database?sslmode=disable"
  #}
  depends_on = [
    #module.aws_db_instance.rds
  ]
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.db.path
  name                = "postgres_db_role"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
  #namespace=var.vault_namespace
  depends_on = [
    vault_mount.db
  ]
}

resource "vault_mount" "kv2" {
  path        = "kv"
  type        = "kv-v2"
  description = "kv-v2 secret engine"
  #namespace = var.vault_namespace
}

resource "vault_generic_secret" "ssh_key" {
  path = "kv/my-secret"
  #namespace = var.vault_namespace
  data_json = jsonencode({
  "username": "ubuntu",
  "private_key": "${var.boundary_aws_targets.ssh_private_key_pem}"
})
depends_on = [
  vault_mount.kv2,
]
}

output "database_connection_string" {
  value = vault_database_secret_backend_connection.postgres.postgresql[0].connection_url
}

output "database_name_from_vault_backend" {
  value = vault_database_secret_backend_connection.postgres.name
}

output "vault_token_boundary_periodic" {
  value = vault_token.boundary_token
}
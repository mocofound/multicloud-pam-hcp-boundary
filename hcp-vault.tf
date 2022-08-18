resource "hcp_vault_cluster" "my_cluster" {
  cluster_id = "hcp-tf-boundary-vault-cluster"
  hvn_id = "boundary-hvn"
  public_endpoint = true
  #cloud_provider = "aws"
}

resource "hcp_vault_cluster_admin_token" "my_token" {
  cluster_id = hcp_vault_cluster.my_cluster.cluster_id
}

resource "vault_generic_secret" "ssh_key" {
  path = "kv/my-secret"
  data_json = jsonencode({
  "username": "ubuntu",
  "private_key": "${tls_private_key.hashicat.private_key_pem}"
})
}

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

path "*" {
  capabilities = ["read"]
}

EOT
}

output "hcp_vault_cluster_admin_token" {
  sensitive = true
  value = hcp_vault_cluster_admin_token.my_token.token

}

output "hcp_vault_cluster_public_ip" {
  value = hcp_vault_cluster.my_cluster.vault_public_endpoint_url
}
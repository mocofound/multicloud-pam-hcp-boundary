#!/bin/bash
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary_login_name=$(terraform output -raw boundary_login_name)
echo ${boundary_login_name}
boundary_login_password=$(terraform output -raw boundary_login_password)
echo ${boundary_login_password}
boundary_password_auth_method_id=$(terraform output -raw boundary_password_auth_method_id)
echo ${boundary_password_auth_method_id}
boundary authenticate password -login-name ${boundary_login_name} -auth-method-id ${boundary_password_auth_method_id}
boundary_vault_credential_store=$(terraform output -raw boundary_vault_credential_store)
echo ${boundary_vault_credential_store}
boundary credential-libraries create vault \
 -name aws_ssh_private_key_cred_lib_2 -credential-store-id ${boundary_vault_credential_store} -vault-path "kv/data/my-secret" \
  -credential-type=ssh_private_key -description "CLI manual creation for private ssh key creds"
boundary credential-libraries list -credential-store-id ${boundary_vault_credential_store}
#Then, take the ID: from the credential library with Credential Type: ssh_private_key and paste that into main_step_3 resource "boundary_target" "aws_ssh" application_credential_source_ids = []
#terraform init
#terraform apply

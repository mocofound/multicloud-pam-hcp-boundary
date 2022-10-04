#!/bin/bash
set -aex
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
#boundary_addr=$(terraform output -raw boundary_addr)
boundary_addr="https://7fd7b4f5-f38a-4570-9829-8bbc07b6b5a8.boundary.hashicorp.cloud"
export BOUNDARY_ADDR=${boundary_addr}
boundary_login_name=$(terraform output -raw boundary_login_name)
echo ${boundary_login_name}
boundary_login_password=$(terraform output -raw boundary_login_password)
echo ${boundary_login_password}
boundary_password_auth_method_id="ampw_KE8N7FFQSV"
#boundary_password_auth_method_id=$(terraform output -raw boundary_password_auth_method_id)
echo ${boundary_password_auth_method_id}
boundary authenticate password -login-name ${boundary_login_name} -auth-method-id ${boundary_password_auth_method_id}
#boundary host-sets list
boundary targets list -recursive
boundary targets delete -id ttcp_i9IIglt6Qb
    # accounts
    # auth-methods
    # auth-tokens
    # authenticate
    # config
    # connect
    # credential-libraries
    # credential-stores
    # credentials
    # database
    # dev
    # groups
    # host-catalogs
    # host-sets
    # hosts
    # logout
    # managed-groups
    # roles
    # scopes
    # server
    # sessions
    # targets
    # users
    # workers
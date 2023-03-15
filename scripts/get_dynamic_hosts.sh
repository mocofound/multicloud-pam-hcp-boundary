#!/bin/bash
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary_oidc_auth_method_id=$(terraform output -raw boundary_oidc_auth_method_id)
echo ${boundary_oidc_auth_method_id}
boundary_password_auth_method_id="ampw_ocFcdIi8Oa"



boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary_login_name=$(terraform output -raw boundary_login_name)
echo ${boundary_login_name}
boundary_login_password=$(terraform output -raw boundary_login_password)
echo ${boundary_login_password}
boundary_password_auth_method_id=$(terraform output -raw boundary_password_auth_method_id)
echo ${boundary_password_auth_method_id}
boundary authenticate password -login-name ${boundary_login_name} -auth-method-id ${boundary_password_auth_method_id}

boundary auth-methods list
boundary auth-methods read -id amoidc_th6a5xrmlr
boundary host-catalogs list -recursive -scope-id global
boundary host-catalogs read -id hcplg_GdBahgfBfF
boundary hosts list -host-catalog-id "hcplg_GdBahgfBfF"
boundary hosts read -id "hplg_qAvBfIICg5"
boundary hosts read -id "hplg_29UQcwDkQU"


boundary host-catalogs


# boundary authenticate oidc -auth-method-id ${boundary_oidc_auth_method_id}
# sleep 2

# boundary hosts list -host-catalog-id "hcplg_3U2CWNWAtL"

#!/bin/bash
set -aex
#chmod a+x ./scripts/boundary_test_oidc_user_aws_postgres.sh
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
unset BOUNDARY_ADDR
boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary_oidc_auth_method_id=$(terraform output -raw boundary_oidc_auth_method_id)
echo ${boundary_oidc_auth_method_id}

boundary authenticate oidc -auth-method-id ${boundary_oidc_auth_method_id}
sleep 2


boundary connect postgres -target-name postgres_db_target -target-scope-name project_aws -dbname rdsdb -- -exec "\du"

boundary connect postgres -target-name postgres_db_target -target-scope-name project_aws -dbname rdsdb 


#List All Postgres Users and show dynamically created vault users
#rdsdb=> \du


#!/bin/bash
set -aex
#chmod a+x ./scripts/boundary_test_oidc_user_aws_ssh.sh
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
echo "DON'T FORGET:  Make nessecary app registration changes in AzureAD"
unset BOUNDARY_ADDR
boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary_oidc_auth_method_id=$(terraform output -raw boundary_oidc_auth_method_id)
echo ${boundary_oidc_auth_method_id}

boundary authenticate oidc -auth-method-id ${boundary_oidc_auth_method_id}
sleep 2
boundary targets list -recursive
boundary connect ssh -target-name aws_ec2_ssh_target -target-scope-name project_aws
#boundary connect ssh -target-id tssh_jHLvZpOhW5 -- -l ubuntu -i ../boundary.pem
#chmod 600 ./boundary-key-pair.pem 
#ssh -i ./boundary-key-pair.pem ubuntu@ec2-34-227-187-120.compute-1.amazonaws.com
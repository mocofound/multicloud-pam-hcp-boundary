#!/bin/bash
set -aex
#chmod a+x ./scripts/boundary_test_oidc_user_aws_ssh.sh
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
boundary_addr=$(terraform output boundary_addr | xargs)
export BOUNDARY_ADDR=${boundary_addr}
boundary authenticate oidc -auth-method-id amoidc_3eHzRU9PRH
sleep 2
boundary connect ssh -target-name aws_ec2_ssh_target -target-scope-name project_aws

#chmod 600 ./boundary-key-pair.pem 
#ssh -i ./boundary-key-pair.pem ubuntu@ec2-34-227-187-120.compute-1.amazonaws.com
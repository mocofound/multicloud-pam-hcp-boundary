#!/bin/sh
#set -aex
set -ax
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
#boundary_addr=$(terraform output -raw boundary_addr)
boundary_addr="https://7fd7b4f5-f38a-4570-9829-8bbc07b6b5a8.boundary.hashicorp.cloud"
export BOUNDARY_ADDR=${boundary_addr}
boundary_login_name=$(terraform output -raw boundary_login_name)
echo ${boundary_login_name}
boundary_login_password=$(terraform output -raw boundary_login_password)
echo ${boundary_login_password}
boundary_password_auth_method_id="ampw_ocFcdIi8Oa"
#boundary_password_auth_method_id=$(terraform output -raw boundary_password_auth_method_id)
echo ${boundary_password_auth_method_id}
boundary authenticate password -login-name ${boundary_login_name} -auth-method-id ${boundary_password_auth_method_id}
# echo "Please Input Worker Registration Token: "
# read workertoken
# export WORKER_TOKEN=${workertoken}
# boundary workers create worker-led -worker-generated-auth-token=$WORKER_TOKEN
sleep 1
boundary workers list
echo "enter workerID to remove:"
read workerID
boundary workers delete -id ${workerID}
#boundary workers read -id w_r61cCrlm4M
# boundary targets list -recursive
# echo "Please Input TargetID to use with Self-Managed Worker: "
# read targetid
# export TARGET_ID=${targetid}
# #boundary targets update tcp -id $TARGET_ID -worker-filter='"azure" in "/tags/type"'
# boundary targets update tcp -id $TARGET_ID -worker-filter='"worker" in "/tags/type"'
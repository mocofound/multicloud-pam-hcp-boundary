#!/bin/bash
export BOUNDARY_ADDR="https://12345-05ee-4e23-bb56-5ada2cbf7628.boundary.hashicorp.cloud"
boundary authenticate oidc -auth-method-id amoidc_qhb1gUU3U5
boundary connect ssh -target-name aws_target_1 -target-scope-name project_aws
boundary connect ssh -target-id ttcp_A5QlP4Box1 

boundary authenticate password 


#boundary authenticate password -auth-method-id ampw_l8U277lBcI  -login-name myboundaryuser1

#boundary auth-methods list
#boundary accounts -h
#boundary accounts list -h
#boundary accounts list -auth-method-id amoidc_qhb1gUU3U5

#chmod 600 ./boundary-key-pair.pem 
#ssh -i ./boundary-key-pair.pem ubuntu@ec2-34-227-187-120.compute-1.amazonaws.com

#boundary authenticate oidc -auth-method-id amoidc_qhb1gUU3U5
#boundary scopes list
#boundary targets list -recursive -scope-id o_mdVwG3kyQ4
#boundary targets list -scope-id p_CwM5o2VQ9W
#boundary connect ssh -h
#boundary connect ssh -target-id ttcp_A5QlP4Box1 
#boundary connect ssh -target-name aws_target_1 -target-scope-name project_aws




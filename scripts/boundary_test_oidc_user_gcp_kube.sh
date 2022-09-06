#!/bin/bash
set -aex
//https://learn.hashicorp.com/tutorials/terraform/gke
#chmod a+x ./scripts/boundary_test_oidc_user_gcp_kube.sh
#export BOUNDARY_ADDR="https://b82c1c5a-b8c5-4415-8b37-564ff9259487.boundary.hashicorp.cloud/"
boundary_addr=$(terraform output -raw boundary_addr)
export BOUNDARY_ADDR=${boundary_addr}
boundary authenticate oidc -auth-method-id amoidc_3eHzRU9PRH
sleep 2
gcloud components install gke-gcloud-auth-plugin 
gcloud components install kubectl
gcloud container clusters get-credentials $(terraform output -raw gcp_kubernetes_cluster_name) --region $(terraform output -raw gcp_region)

#from multi-cloud consul instruqt lab lance
gcloud container clusters get-credentials $(terraform output gcp_gke_cluster_shared_name) --region us-central1-a
kubectl config rename-context $(kubectl config current-context) shared
kubectl config use-context shared
kubectl get nodes
ssh ubuntu@$(terraform output -state /root/terraform/cts/terraform.tfstate aws_cts_public_ip) 'tail -f /var/log/cloud-init-output.log'

How to use local remote state
data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../iam/terraform.tfstate"
  }
}


#WARNING: cluster boundary-poc-3-gke is not RUNNING. The kubernetes API may or may not be available. Check the cluster status for more information.
#FIX?:Just Run get-credentials again
#TODO
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
boundary connect kube -target-name aws_ec2_ssh_target -target-scope-name project_aws

#chmod 600 ./boundary-key-pair.pem 
#ssh -i ./boundary-key-pair.pem ubuntu@ec2-34-227-187-120.compute-1.amazonaws.com
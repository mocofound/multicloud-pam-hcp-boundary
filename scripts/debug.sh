unset TF_LOG
export TF_LOG_PROVIDER=DEBUG

pwd
mkdir debug
export TF_LOG_PROVIDER=DEBUG
export TF_LOG_PATH=~/Documents/GitHub/hcp-boundary-vault-demo/debug/debug.out
terraform apply -auto-approve

module.boundary.boundary_credential_store_vault.vault_cred_store: Creating...
2022-08-29T12:06:11.427-0500 [ERROR] provider.terraform-provider-boundary_v1.0.11_x5: Response contains error diagnostic: tf_resource_type=boundary_credential_store_vault tf_rpc=ApplyResourceChange @module=sdk.proto diagnostic_detail= diagnostic_severity=ERROR diagnostic_summary="error creating credential store: {"kind":"InvalidArgument","message":"Invalid request.  Request attempted to make second resource with the same field value that must be unique."}" tf_proto_version=5.3 tf_req_id=2ea44f33-b377-e44e-72ce-2fc9260527c2 @caller=github.com/hashicorp/terraform-plugin-go@v0.14.0/tfprotov5/internal/diag/diagnostics.go:55 tf_provider_addr=provider timestamp=2022-08-29T12:06:11.427-0500
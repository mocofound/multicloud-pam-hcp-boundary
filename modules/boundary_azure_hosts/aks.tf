module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~>6.1.0"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location = var.location
  #Uncomment below to make private vs. public AKS cluster
  #vnet_subnet_id = azurerm_subnet.subnet.id
  #private_cluster_enabled = true
  depends_on = [
    azurerm_resource_group.myresourcegroup
  ]
}
#local file kubeconfig https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/aks/kubernetes-config/main.tf

output "kubeconfig_path" {
  value = abspath("${path.root}/kubeconfig")
}

resource "local_file" "kubeconfig" {
  content = module.aks.kube_config_raw
  filename = "${path.root}/kubeconfig"
}




# output "cluster_name" {
#   value = local.cluster_name
# }

# https://github.com/hashicorp/boundary-reference-architecture/tree/main/deployment/kube/kubernetes

# https://registry.terraform.io/modules/Azure/aks/azurerm/latest?tab=outputs
# Outputs from Module
# kube_admin_config_raw
# Description: The `azurerm_kubernetes_cluster`'s `kube_admin_config_raw` argument. Raw Kubernetes config for the admin account to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools. This is only available when Role Based Access Control with Azure Active Directory is enabled and local accounts enabled.
# kube_config_raw
# Description: The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools.
# kubelet_identity
# Description: The `azurerm_kubernetes_cluster`'s `kubelet_identity` block.
# client_certificate
# Description: The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster.
# client_key
# Description: The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster.
# cluster_ca_certificate
# Description: The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster.
# cluster_fqdn
# Description: The FQDN of the Azure Kubernetes Managed Cluster.
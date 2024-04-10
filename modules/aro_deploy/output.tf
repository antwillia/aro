output "console_url" {
  value = azurerm_redhat_openshift_cluster.cluster.console_url
}

output "kubeadmin" {
  value = azapi_resource_action.kubeadmin.output
}

output "kubeconfig" {
  value = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
  sensitive = true
}
output "kubeconfig" {
  value = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
  sensitive = true
}
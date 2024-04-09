data "azurerm_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azurerm_resource_group" "aro-rg" {
  name = var.resource_group_name
}

resource "azapi_resource_action" "test" {
  type        = "Microsoft.RedHatOpenShift/openShiftClusters@2023-07-01-preview"
  resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.aro-rg.name}/providers/Microsoft.RedHatOpenShift/openShiftClusters/aro-atwlab"
  action      = "listAdminCredentials"
  method      = "POST"
  response_export_values = ["*"]
}

resource "azurerm_key_vault" "atwlab-vault" {
  depends_on = [ azapi_resource_action.test ]
  name                       = "atwlab-vault"
  location                   = data.azurerm_resource_group.aro-rg.location
  resource_group_name        = data.azurerm_resource_group.aro-rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 90
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "atw-rbac" {
  depends_on = [ azurerm_key_vault.atwlab-vault ]
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "kubeconfig" {
  depends_on = [ azurerm_role_assignment.atw-rbac ]
  name         = "kubeconfig"
  value        = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
  key_vault_id = azurerm_key_vault.atwlab-vault.id
}

resource "local_file" "kubeconfig" {
  depends_on = [ azurerm_key_vault_secret.kubeconfig ]
  content = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
  filename = format("%s/%s/config", var.user_home_dir, var.cluster_name)
}
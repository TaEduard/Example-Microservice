data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "Kv1" {
  name                       = "kubernetesSecrets${random_string.example.result}"
  location                   = azurerm_resource_group.aks_rg.location
  resource_group_name        = azurerm_resource_group.aks_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "kubeconfig" {
  name         = "kubeconfig"
  value        = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  key_vault_id = azurerm_key_vault.Kv1.id

  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster,
  ]
}

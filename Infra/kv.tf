data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "Kv1" {
  name                       = "kv-${random_string.example.result}"
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

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = azurerm_key_vault.Kv1.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

secret_permissions = ["Get","List","Set","Delete","Recover","Backup","Restore","Purge"]
  depends_on = [
    azurerm_key_vault.Kv1
  ]
}


resource "azurerm_key_vault_secret" "kubeconfig" {
  name         = "kubeconfig-${random_string.example.result}"
  value        = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  key_vault_id = azurerm_key_vault.Kv1.id

  depends_on = [
    azurerm_key_vault_access_policy.policy,
    azurerm_kubernetes_cluster.aks_cluster,
  ]
}

resource "azurerm_key_vault_access_policy" "policyVM" {
  key_vault_id = azurerm_key_vault.Kv1.id

  tenant_id = azurerm_virtual_machine.runner_vm.identity.0.tenant_id
  object_id = azurerm_virtual_machine.runner_vm.identity.0.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
  depends_on = [ azurerm_virtual_machine.runner_vm ]
}

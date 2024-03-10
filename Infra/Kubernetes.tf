resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  # Updated to restrict API server access
  api_server_access_profile {
    # Remove or adjust this line to change public API access. To restrict access, specify a limited set of IP ranges.
     authorized_ip_ranges = [var.default_subnet]
  }

  tags = {
    Environment = "Terraform AKS"
  }
}

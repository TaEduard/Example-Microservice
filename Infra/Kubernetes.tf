resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Terraform AKS"
  }
}
resource "null_resource" "apply_k8s_config" {
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]

  provisioner "local-exec" {
    command = "kubectl apply -f ./Yaml/nginx.yaml --kubeconfig=./kubeconfig"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

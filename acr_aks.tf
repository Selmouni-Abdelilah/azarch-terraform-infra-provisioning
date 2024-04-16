resource "azurerm_container_registry" "acr" {
  name                = var.azarch-acr-name
  resource_group_name = azurerm_resource_group.azarch-rg.name
  location            = azurerm_resource_group.azarch-rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
resource "azurerm_kubernetes_cluster" "azarch-aks-cluster" {
  name                = var.azarch-aks_cluster_name
  location            = azurerm_resource_group.azarch-rg.location
  resource_group_name = azurerm_resource_group.azarch-rg.name
  dns_prefix          = "exampleaks1"

  sku_tier = "Free"
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [ default_node_pool ,microsoft_defender]
  }
}
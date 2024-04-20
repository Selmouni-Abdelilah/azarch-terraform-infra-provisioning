resource "azurerm_container_registry" "acr" {
  name                = var.azarch-acr-name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
# Create Virtual Network
resource "azurerm_virtual_network" "aksvnet" {
  name                = "aks-network"
  location            = data.azurerm_resource_group.azarch-rg.location
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  address_space       = ["10.0.0.0/8"]
}

# Create a Subnet for AKS
resource "azurerm_subnet" "aks-default" {
  name                 = "aks-default-subnet"
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = data.azurerm_resource_group.azarch-rg.name
  address_prefixes     = ["10.240.0.0/16"]
}
resource "azurerm_kubernetes_cluster" "azarch-aks-cluster" {
  name                = var.azarch-aks_cluster_name
  location            = data.azurerm_resource_group.azarch-rg.location
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  dns_prefix          = "azarchaks1"
  
  sku_tier = "Free"
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks-default.id
  }

  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [ default_node_pool ,microsoft_defender]
  }
}
# Create private endpoint for SQL server
resource "azurerm_private_dns_zone" "aks_dns_zone" {
  name                = "akslink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
}
resource "azurerm_private_endpoint" "aks_endpoint" {
  name                = "private-endpoint-sql-aks"
  location            = data.azurerm_resource_group.azarch-rg.location
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  subnet_id           = azurerm_subnet.aks-default.id

  private_service_connection {
    name                           = "aks-serviceconnection"
    private_connection_resource_id = azurerm_mssql_server.azarch-mssql-server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.aks_dns_zone.id]
  }
}

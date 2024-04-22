resource "azurerm_virtual_network" "appgateway-vnet" {
  name                = "appgateway-vnet"
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  address_space       = ["172.14.0.0/16"]
}

resource "azurerm_subnet" "appgateway-subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = data.azurerm_resource_group.azarch-rg.name
  virtual_network_name = azurerm_virtual_network.appgateway-vnet.name
  address_prefixes     = ["172.14.0.0/24"]
  service_endpoints = ["Microsoft.Web"]
}
#Configure peering between VM and AppGw
resource "azurerm_virtual_network_peering" "peervm2appgw" {
  name                      = "peervm2appgw"
  resource_group_name       = data.azurerm_resource_group.azarch-rg.name
  virtual_network_name      = azurerm_virtual_network.azarch-vm-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.appgateway-vnet.id
}

resource "azurerm_virtual_network_peering" "peerappgw2vm" {
  name                      = "peerappgw2vm"
  resource_group_name       = data.azurerm_resource_group.azarch-rg.name
  virtual_network_name      = azurerm_virtual_network.appgateway-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.azarch-vm-vnet.id
}

resource "azurerm_public_ip" "appgw-pip" {
  name                = "appgw-pip"
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  sku = "Standard"
  allocation_method   = "Static"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  frontend_port_name             = "${azurerm_virtual_network.appgateway-vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.appgateway-vnet.name}-feip"
  redirect_configuration_name    = "${azurerm_virtual_network.appgateway-vnet.name}-rdrcfg"
  url_path_map                   =  "${azurerm_virtual_network.appgateway-vnet.name}-upm"  
  listener_name                  = "${azurerm_virtual_network.appgateway-vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.appgateway-vnet.name}-rqrt"


  backend_address_pool_name_catalog      = "${azurerm_virtual_network.appgateway-vnet.name}-beap-catalog"
  http_setting_name_catalog              = "${azurerm_virtual_network.appgateway-vnet.name}-be-htst-catalog"

  backend_address_pool_name      = "${azurerm_virtual_network.appgateway-vnet.name}-beap-inventory"
  http_setting_name_inventory              = "${azurerm_virtual_network.appgateway-vnet.name}-be-htst-inventory"

}

resource "azurerm_application_gateway" "azarch-appgw" {
  name                = "azarch-appgateway"
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-config"
    subnet_id = azurerm_subnet.appgateway-subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw-pip.id
  }
 # Catalog VM backend
  backend_address_pool {
    name = local.backend_address_pool_name_catalog
    ip_addresses = [azurerm_windows_virtual_machine.azarch-vm.private_ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name_catalog
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
# Inventory App Service backend
  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [ azurerm_linux_web_app.azarch-webapp.default_hostname ]
  }

  backend_http_settings {
    name                  = local.http_setting_name_inventory
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    pick_host_name_from_backend_address = true
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "PathBasedRouting"
    http_listener_name         = local.listener_name
    url_path_map_name = local.url_path_map 
  }
  url_path_map {
    name = local.url_path_map 
    default_redirect_configuration_name = local.redirect_configuration_name
    path_rule {
      name = "catalog-rule"
      paths = ["/*"]
      backend_address_pool_name = local.backend_address_pool_name_catalog
      backend_http_settings_name = local.http_setting_name_catalog
    }
    path_rule {
      name = "inventory-rule"
      paths = ["/inventory/"]
      backend_address_pool_name = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name_inventory       
    }    
  }
  redirect_configuration {
    name = local.redirect_configuration_name
    redirect_type = "Permanent"
    target_url = "https://azure.microsoft.com/en-us/"
  }
}
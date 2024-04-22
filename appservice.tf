resource "azurerm_service_plan" "azarch-svc-plan-webapp" {
  name                = var.service_plan-webapp_name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}
resource "azurerm_linux_web_app" "azarch-webapp" {
  name                = var.azarch-webapp-name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = azurerm_service_plan.azarch-svc-plan-webapp.location
  service_plan_id     = azurerm_service_plan.azarch-svc-plan-webapp.id
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION ="~4"
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
  
  }
  identity {
    type = "SystemAssigned"    
  }
  lifecycle {
    ignore_changes = [ app_settings ]
  }
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    ip_restriction {
      action                  = "Allow"
      priority = 100
      virtual_network_subnet_id = azurerm_subnet.appgateway-subnet.id
    }
  }
}
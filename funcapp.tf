resource "azurerm_storage_account" "azarch-functionapps-storage" {
  name                     = var.storage_account_functionapps_name
  resource_group_name      = data.azurerm_resource_group.azarch-rg.name
  location                 = data.azurerm_resource_group.azarch-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "azarch-svc-plan" {
  name                = var.service_plan_name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "azarch-functionapps" {
  name                = var.function_app_name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  location            = data.azurerm_resource_group.azarch-rg.location
  builtin_logging_enabled = true
  https_only = true
  storage_account_name       = azurerm_storage_account.azarch-functionapps-storage.name
  storage_account_access_key = azurerm_storage_account.azarch-functionapps-storage.primary_access_key
  service_plan_id            = azurerm_service_plan.azarch-svc-plan.id
  
  app_settings = {
    FUNCTIONS_EXTENSION_VERSION ="~4"
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
  
  }
  lifecycle {
    ignore_changes = [ app_settings ]
  }

  site_config {
    always_on = true
    ip_restriction {
      action      = "Allow"
      priority    = 100
      name        = "allowonlyeventgrid"
      service_tag = "AzureEventGrid"
    }
    application_stack {
      dotnet_version = "6.0"
    }
  }
}

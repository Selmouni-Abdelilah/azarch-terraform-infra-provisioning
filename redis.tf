resource "azurerm_redis_cache" "azarch-redis-cache" {
  name                = var.azarch-redis-cache_name
  location            = data.azurerm_resource_group.azarch-rg.location
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}

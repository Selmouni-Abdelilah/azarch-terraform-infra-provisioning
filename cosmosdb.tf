# Cosmos DB
resource "azurerm_cosmosdb_account" "azarch-cosmosdb-account" {
  name                      = var.cosmosdb_account_name
  location                  = data.azurerm_resource_group.azarch-rg.location
  resource_group_name       = data.azurerm_resource_group.azarch-rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  enable_free_tier = true
  geo_location {
    location          = data.azurerm_resource_group.azarch-rg.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    data.azurerm_resource_group.azarch-rg
  ]
}
resource "azurerm_cosmosdb_sql_database" "azarch-cosmosdb-database" {
  name                = var.cosmosdb_database_name
  resource_group_name = data.azurerm_resource_group.azarch-rg.name
  account_name        = azurerm_cosmosdb_account.azarch-cosmosdb-account.name
}

resource "azurerm_cosmosdb_sql_container" "azarch-cosmosdb-container" {
  name                  = var.cosmosdb_container_name
  resource_group_name   = data.azurerm_resource_group.azarch-rg.name
  account_name          = azurerm_cosmosdb_account.azarch-cosmosdb-account.name
  database_name         = azurerm_cosmosdb_sql_database.azarch-cosmosdb-database.name
  partition_key_path    = "/priority"
  partition_key_version = 1
  autoscale_settings {
    max_throughput = 1000
  }
  indexing_policy {
    
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
  
}
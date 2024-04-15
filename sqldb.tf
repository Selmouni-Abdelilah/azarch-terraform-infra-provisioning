resource "azurerm_mssql_server" "example-2" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.azarch-rg.name
  location                     = azurerm_resource_group.azarch-rg.location
  version                      = "12.0"
  minimum_tls_version          = "1.2"
  administrator_login = var.db_admin_login
  administrator_login_password = var.db_admin_password

  azuread_administrator {
    azuread_authentication_only = false
    login_username = "ServerAdmin"
    object_id      = "3a4e84cb-247e-40e8-8c96-22d982f081e6"
  }
}

resource "azurerm_mssql_database" "example" {
  name           = var.mssql_database_name
  server_id      = azurerm_mssql_server.example-2.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "GP_S_Gen5_1"
  zone_redundant = false
}
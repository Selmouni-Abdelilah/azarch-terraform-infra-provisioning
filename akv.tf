data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "azarch-key-vault" {
  name                        = var.azarch-key-vault-name
  location                    = data.azurerm_resource_group.azarch-rg.location
  resource_group_name         = data.azurerm_resource_group.azarch-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name = "standard"
  enable_rbac_authorization = true
}
resource "azurerm_storage_account" "azarch-eventgrid-storage-acc" {
  name                     = var.storage_account_eventgrid_name
  resource_group_name      = data.azurerm_resource_group.azarch-rg.name
  location                 = data.azurerm_resource_group.azarch-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "azarch-eventgrid-storage-container" {
  name                = var.storage_container_name
  container_access_type="private"
  storage_account_name = azurerm_storage_account.azarch-eventgrid-storage-acc.name  
}
resource "azurerm_eventgrid_system_topic" "azarch-eventgrid-system-topic" {
  name                   = var.system_topic_name
  location               = data.azurerm_resource_group.azarch-rg.location
  resource_group_name    = data.azurerm_resource_group.azarch-rg.name
  source_arm_resource_id = azurerm_storage_account.azarch-eventgrid-storage-acc.id
  topic_type             = "Microsoft.Storage.StorageAccounts"
}

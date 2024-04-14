resource "azurerm_resource_group" "azarch-rg" {
  name     = var.resource_group_name
  location = "eastus"
}
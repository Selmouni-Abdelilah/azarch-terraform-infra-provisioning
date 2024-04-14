variable "cosmosdb_account_name" {
  type    = string
  default = "azarch-cosmosdb-acc-37"
}

variable "cosmosdb_database_name" {
  type    = string
  default = "azarch-orders"
}

variable "cosmosdb_container_name" {
  type    = string
  default = "orders"
}

variable "storage_account_eventgrid_name" {
  type    = string
  default = "azarcheventgridstorageacc"
}

variable "storage_account_functionapps_name" {
  type    = string
  default = "azarchfuncappstrgacc"
}

variable "storage_container_name" {
  type    = string
  default = "neworders"
}

variable "system_topic_name" {
  type    = string
  default = "azarch-system-topic"
}

variable "resource_group_name" {
  type    = string
  default = "azarch-resource-group"
}

variable "function_app_name" {
  type    = string
  default = "azarch-function-app"
}

variable "service_plan_name" {
  type    = string
  default = "azarch-app-service-plan"
}

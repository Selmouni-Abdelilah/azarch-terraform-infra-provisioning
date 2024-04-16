# Azure Cosmos DB Account Name
variable "cosmosdb_account_name" {
  type        = string
  default     = "azarch-cosmosdb-acc-37"
  description = "The name of the Azure Cosmos DB account."
}

# Azure Cosmos DB Database Name
variable "cosmosdb_database_name" {
  type        = string
  default     = "azarch-orders"
  description = "The name of the Azure Cosmos DB database"
}

# Azure Cosmos DB Container Name
variable "cosmosdb_container_name" {
  type        = string
  default     = "orders"
  description = "The name of the Azure Cosmos DB container."
}

# Storage Account Name for Event Grid
variable "storage_account_eventgrid_name" {
  type        = string
  default     = "azarcheventgridstrgacc"
  description = "The name of the storage account for Event Grid."
}

# Storage Account Name for Function Apps
variable "storage_account_functionapps_name" {
  type        = string
  default     = "azarchfuncappstrgacc"
  description = "The name of the storage account for Function Apps."
}

# Storage Container Name
variable "storage_container_name" {
  type        = string
  default     = "neworders"
  description = "The name of the storage container."
}

# Event Grid System Topic Name
variable "system_topic_name" {
  type        = string
  default     = "azarch-system-topic"
  description = "The name of the Event Grid system topic."
}

# Resource Group Name
variable "resource_group_name" {
  type        = string
  default     = "azarch-resource-group"
  description = "The name of the Azure resource group."
}

# Function App Name
variable "function_app_name" {
  type        = string
  default     = "azarch-function-app"
  description = "The name of the Function App."
}

# App Service Plan Name
variable "service_plan_name" {
  type        = string
  default     = "azarch-app-service-plan"
  description = "The name of the Azure App Service plan."
}

# Network Security Group Name for Virtual Machine
variable "azarch-vm-nsg_name" {
  type        = string
  default     = "azarch-vm-nsg"
  description = "The name of the network security group for the virtual machine."
}

# Virtual Network Name for Virtual Machine
variable "azarch-vm-vnet_name" {
  type        = string
  default     = "azarch-vm-vnet"
  description = "The name of the virtual network for the virtual machine."
}

# Subnet Name for Virtual Machine
variable "azarch-vm-subnet_name" {
  type        = string
  default     = "azarch-vm-subnet"
  description = "The name of the subnet for the virtual machine."
}

# Virtual Machine Name
variable "azarch-vm_name" {
  type        = string
  default     = "azarch-vm"
  description = "The name of the virtual machine."
}

# Username for Virtual Machine
variable "azarch-vm_username" {
  type        = string
  description = "The username for accessing the virtual machine."
}

# Password for Virtual Machine
variable "azarch-vm_passwd" {
  type        = string
  sensitive   = true
  description = "The password for accessing the virtual machine."
}
variable "service_plan-webapp_name" {
  type = string
  default = "azarch-webapp-svc-plan"
  description = "The name of inventory web app service plan"
}
# App SErvice Name
variable "azarch-webapp-name" {
  type = string
  default = "azarchinventorywebapp"
  description = "The name of inventory web app"
}

variable "mssql_server_name" {
  type = string
  default = "azarch-sql-server"
  description = "The name of sql server"
}
variable "mssql_database_name" {
  type = string
  default = "azarch-sql-database"
  description = "The name of sql databse"
}
variable "db_admin_login" {
  type = string
  description = "The username for accessing the DB"
}

variable "db_admin_password" {
  type = string
  sensitive = true
  description = "The password for accessing the DB"
}

variable "azarch-acr-name" {
  type = string
  default = "azarchcontainerRegistry"
  description = "ACR name"
}
variable "azarch-aks_cluster_name" {
  type = string
  default = "azarch-aks1"
  description = "AKS cluster name"
}

variable "azarch-redis-cache_name"{
  type = string
  default = "azarch-redis-cache"
  description = "Azure Redis Cache name"
}
resource "azurerm_resource_group" "rg" {
    count = var.create_resource_group ? 1 : 0
    name = var.resource_group
    location = var.location
}

data "azurerm_resource_group" "rg" {
    count = var.create_resource_group ? 0 : 1
    name = var.resource_group
}

data "azurerm_container_registry" "acr" {
  name                = var.acr.name
  resource_group_name = var.acr.resource_group_name
}

data "azurerm_log_analytics_workspace" "logAnalytics" {
  name = var.log_analytics.name
  resource_group_name = var.log_analytics.resource_group_name
}
locals {
  rg_name     = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  rg_location = var.create_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.rg[0].location
  cae_id      = var.create_container_app_env ? azurerm_container_app_environment.containerAppEnv[0].id : data.azurerm_container_app_environment.containerAppEnv[0].id
}

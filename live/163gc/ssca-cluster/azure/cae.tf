resource "azurerm_container_app_environment" "containerAppEnv" {
  name                       = "${var.cae_name}-cae"
  location                   = resource.azurerm_resource_group.rg.location
  resource_group_name        = resource.azurerm_resource_group.rg.name
  logs_destination          = "log-analytics"
  log_analytics_workspace_id = 
}
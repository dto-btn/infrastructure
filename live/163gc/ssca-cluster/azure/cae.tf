resource "azurerm_container_app_environment" "containerAppEnv" {
  name                       = "ssca-cae"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  logs_destination          = "log-analytics"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalytics.id
}

resource "azurerm_container_app" "containerApp" {
  name                         = "mcp-server"
  container_app_environment_id = azurerm_container_app_environment.containerAppEnv.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  registry{
    identity = azurerm_user_assigned_identity.mcpImageIdentity.id
    server = "dtoacr.azurecr.io"
  }

  identity{
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mcpImageIdentity.id] 
  }

  template {
    container {
      image = "dtoacr.azurecr.io/ssca-mcp-server:v1"
      name  = "ssca-mcp-server"
      cpu    = 2
      memory = "4Gi"
    }
  }
}
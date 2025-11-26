resource "azurerm_container_app_environment" "containerAppEnv" {
  name                       = var.container_app_environment_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  logs_destination          = "log-analytics"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalytics.id
}

resource "azurerm_container_app" "containerApp" {
  name                         = var.container_app.name
  container_app_environment_id = azurerm_container_app_environment.containerAppEnv.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = var.container_app.revision_mode

  registry{
    identity = azurerm_user_assigned_identity.mcpImageIdentity.id
    server = data.azurerm_container_registry.acr.login_server
  }

  identity{
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mcpImageIdentity.id] 
  }

  template {
    container {
      image = "${data.azurerm_container_registry.acr.login_server}/${var.acr.image.repo_name}:${var.acr.image.tag}"
      name  = var.container_app.name
      cpu    = 2
      memory = "4Gi"
    }
  }

  ingress {
    external_enabled = true
    client_certificate_mode = "ignore"
    target_port = 8000
    transport = "auto"
    traffic_weight {
      latest_revision = true
      percentage = 100
    }
  }
}
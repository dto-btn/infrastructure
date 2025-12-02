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

data "azuread_application" "container_app_auth" {
  display_name = var.app_registation_name
}

resource "azapi_resource_action" "container_app_auth_settings" {
  type      = "Microsoft.App/containerApps/authConfigs"
  resource_id = "${azurerm_container_app.containerApp.id}/authConfigs/current"

  # Use PATCH to only update auth section
  method = "PATCH" #or patch?

  body = jsonencode({
    "properties": {
          "platform": {
              "enabled": true
          },
          "globalValidation": {
              "unauthenticatedClientAction": "RedirectToLoginPage",
              "redirectToProvider": "azureactivedirectory",
              "excludedPaths": []
          },
          "identityProviders": {
              "azureActiveDirectory": {
                  "registration": {
                      "openIdIssuer": "https://sts.windows.net/d05bc194-94bf-4ad6-ae2e-1db0f2e38f5e/v2.0",
                      "clientId": "5e945d23-48d9-4929-b1a1-93a9ca58f8aa",
                      "clientSecretSettingName": "microsoft-provider-authentication-secret"
                  },
                  "validation": {
                      "allowedAudiences": [
                          "api://5e945d23-48d9-4929-b1a1-93a9ca58f8aa"
                      ],
                      "defaultAuthorizationPolicy": {
                          "allowedPrincipals": {},
                          "allowedApplications": [
                              "5e945d23-48d9-4929-b1a1-93a9ca58f8aa"
                          ]
                      }
                  },
                  "isAutoProvisioned": false
              }
          },
          "login": {
              "routes": {},
              "preserveUrlFragmentsForLogins": false,
              "cookieExpiration": {},
              "nonce": {}
          },
          "encryptionSettings": {}
    }
  })
}

resource "azurerm_container_app" "testcontainerApp" {
  name                         = "testcaontinerapp"
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
      name  = "testcaontinerapp-container"
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
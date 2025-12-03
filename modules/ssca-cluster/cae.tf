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
    allow_insecure_connections = false
    external_enabled = true
    client_certificate_mode = "ignore"
    target_port = 8000
    transport = "auto"
    traffic_weight {
      latest_revision = true
      percentage = 100
    }
    cors {
      allow_credentials_enabled = false
      allowed_headers           = ["*"]
      allowed_methods           = []
      allowed_origins           = ["http://localhost:8080"]
      exposed_headers           = []
      max_age_in_seconds        = 0
    }
  }
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

data "azuread_application" "container_app_app_reg" {
  display_name = var.app_registation_name
}

resource "azapi_resource_action" "container_app_auth_settings" {
  type      = "Microsoft.App/containerApps/authConfigs@2025-02-02-preview"
  resource_id = "${azurerm_container_app.containerApp.id}/authConfigs/current"

  method = "PUT" 

  body = {
    properties: {
          platform: {
              enabled: true
          },
          globalValidation: {
              unauthenticatedClientAction: "RedirectToLoginPage",
              redirectToProvider: "azureactivedirectory",
              excludedPaths: []
          },
          identityProviders: {
              azureActiveDirectory: {
                  registration: {
                      openIdIssuer: "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/v2.0",
                      clientId: data.azuread_application.container_app_app_reg.client_id,
                      clientSecretSettingName: "microsoft-provider-authentication-secret"
                  },
                  validation: {
                      allowedAudiences: [
                          "api://${data.azuread_application.container_app_app_reg.client_id}"
                      ],
                      defaultAuthorizationPolicy: {
                          allowedPrincipals: {},
                          allowedApplications: [
                              "${data.azuread_application.container_app_app_reg.client_id}"
                          ]
                      }
                  },
                  isAutoProvisioned: false
              }
          },
          login: {
              routes: {},
              preserveUrlFragmentsForLogins: false,
              cookieExpiration: {},
              nonce: {}
          },
          encryptionSettings: {}
    }
  }
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
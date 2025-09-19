data "azurerm_resource_group" "rg" {
    name = var.resource_group
}

resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                = "${var.cae_name}-analytics"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "containerappenv" {
  name                       = "${var.cae_name}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logAnalytics.id
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

#build acr image

resource "azurerm_user_assigned_identity" "gitActionRunnerIdentity" {
  location            = data.azurerm_resource_group.rg.location
  name                = "${var.user_assigned_identity_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}
#will need acr pull role

resource "azurerm_container_app_job" "example" {
  name                         = "${var.cae_job_name}"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.containerappenv.id

  replica_timeout_in_seconds = 1800
  replica_retry_limit        = 0
  event_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
    scale {
        min_executions = 0
        max_executions = 10
        polling_interval_in_seconds = 30
        rules {
            name = "${var.}"
            custom_rule_type = github-runner
            metadata = 
            # example purposes
            # {
            #     "githubAPIURL": "https://api.github.com",
            #                             "owner": "dto-btn",
            #                             "repos": "tfrunnertest",
            #                             "runnerScope": "repo",
            #                             "targetWorkflowQueueLength": "1"
            # }
            authentication {
              secret_name = "personal-access-token"
              trigger_parameter = "personalAccessToken"
            }
        }
    }
   
  }
   identity {
       type = "UserAssigned"
       #this is example
       identity_ids = ["/subscriptions/6425f0ed-3443-4139-8361-9b8d3951d43e/resourcegroups/ScDc-CIO-DTO-RPA_AI_Automation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/runnerIdentity"] 
    }

  template {
    container {
      image = "dtocontainer.azurecr.io/dtorunnerimage"
      name  = "testcontainerappsjob0"
      env {
        name = "GITHUB_PAT"
        secret_name = 
      }
    #   "env": [
    #                             {
    #                                 "name": "GITHUB_PAT",
    #                                 "secretRef": "personal-access-token"
    #                             },
    #                             {
    #                                 "name": "GH_URL",
    #                                 "value": "https://github.com/dto-btn/tfrunnertest"
    #                             },
    #                             {
    #                                 "name": "REGISTRATION_TOKEN_API_URL",
    #                                 "value": "https://api.github.com/repos/dto-btn/tfrunnertest/actions/runners/registration-token"
    #                             }
    #                         ],

      cpu    = 2
      memory = "4Gi"
    }
  }
}
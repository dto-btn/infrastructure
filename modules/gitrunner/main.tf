data "azurerm_resource_group" "rg" {
    name = var.resource_group
}

data "azurerm_key_vault" "kv" {
  name                = "${var.key_vault_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}
#incorporate keyvault to store github secret's.  ie. pat
#Grant access to CAE's managed identity access to keyvault
#will cae job managed identity need to be separate?
#look into diff auth method other than PAT tokens

data "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  # location            = data.azurerm_resource_group.rg.location
  # sku                 = "Basic"
  # admin_enabled       = false
}

data "azurerm_log_analytics_workspace" "logAnalytics" {
  name = "${var.log_analytics_workspace_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_app_environment" "containerAppEnv" {
  name                       = "${var.cae_name}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  logs_destination          = "log-analytics"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalytics.id
}

resource "azurerm_container_registry_task" "buildImage" {
  name                  = "buildRunnerImageTask"
  container_registry_id = data.azurerm_container_registry.acr.id
  docker_step {
    dockerfile_path       = "Dockerfile.github"
    context_path         = "https://github.com/Azure-Samples/container-apps-ci-cd-runner-tutorial.git"
    context_access_token = "123"
    image_names = ["githubrunnerimage"]
  }
}

resource "azurerm_user_assigned_identity" "gitActionRunnerIdentity" {
  location            = data.azurerm_resource_group.rg.location
  name                = "${var.user_assigned_identity_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

#can this be achieved here?  role assignments are done by cloud team.
resource "azurerm_role_assignment" "runnerIdentityRole" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.gitActionRunnerIdentity.id
}

resource "azurerm_container_app_job" "containerAppJob" {
  name                         = "${var.cae_job_name}"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.containerAppEnv.id

  replica_timeout_in_seconds = 1800
  replica_retry_limit        = 0
  dynamic "secret" {
    #needs a var and foreach
    name = "personal-access-token"
  }
  event_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
    scale {
        min_executions = 0
        max_executions = 10
        polling_interval_in_seconds = 30
        rules {
            name = "${var.cae_job_name}-github-runner"
            custom_rule_type = "github-runner"
            metadata = {
              "githubAPIURL": "https://api.github.com",
              "owner": "${var.github_repo_owner}",
              "repos": "${var.github_repo_name}",
              "runnerScope": "${var.runner_scope}",
              "targetWorkflowQueueLength": "1"
            }
            authentication {
              secret_name = "personal-access-token"
              trigger_parameter = "personalAccessToken"
            }
        }
    }
   
  }
   identity {
       type = "UserAssigned"
       identity_ids = [azurerm_user_assigned_identity.gitActionRunnerIdentity.id] 
    }

  template {
    # if can't build image declaritely, pass in with var after pipeline runs it before terraform task?
    container {
      #example "dtocontainer.azurecr.io/dtorunnerimage"
      image = "${var.acr_name}.azurecr.io/${var.acr_repo_name}"
      name  = "${var.acr_repo_name}"
      dynamic "env" {
        for_each = var.acr_image_env_var
        content {
          name = each.key
          value = try(each.value.value, null)
          secret_name = try(each.value.secretRef, null)
        }
      }
      cpu    = 2
      memory = "4Gi"
    }
  }
}
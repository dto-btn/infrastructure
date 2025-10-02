data "azurerm_resource_group" "rg" {
    name = var.resource_group
}

data "azurerm_key_vault" "kv" {
  name                = "${var.key_vault.name}"
  resource_group_name = "${var.key_vault.resource_group_name}"
}
#incorporate keyvault to store github secret's.  ie. pat
#Grant access to CAE's managed identity access to keyvault
#will cae job managed identity need to be separate?
#look into diff auth method other than PAT tokens

data "azurerm_container_registry" "acr" {
  name                = "${var.acr.name}"
  resource_group_name = "${var.acr.resource_group_name}"
  # location            = data.azurerm_resource_group.rg.location
  # sku                 = "Basic"
  # admin_enabled       = false
}

data "azurerm_log_analytics_workspace" "logAnalytics" {
  name = "${var.log_analytics_workspace.name}"
  resource_group_name = "${var.log_analytics_workspace.resource_group_name}"
}

data "azurerm_container_app_environment" "containerAppEnvExisting" {
  count = var.use_existing_cae ? 1 : 0
  name = "${var.cae_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_app_environment" "containerAppEnv" {
  count = var.use_existing_cae ? 0 : 1
  name                       = "${var.cae_name}-cae"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  logs_destination          = "log-analytics"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalytics.id
}

resource "azurerm_container_registry_task" "buildImage" {
  name                  = "buildRunnerImageTask"
  container_registry_id = data.azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    # dockerfile_path       = "Dockerfile"
    dockerfile_path       = "${var.github-action-runner-image.dockerFile_path}"
    #TODO
    # context_path         = "https://github.com/dto-btn/git-action-runner"
    context_path         = "${var.github-action-runner-image.context_path}"
    context_access_token = "${var.github-action-runner-image.context_access_token}"
    image_names = ["${var.acr_image_repo_name}"]
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "runtask" {
  container_registry_task_id = azurerm_container_registry_task.buildImage.id
}

resource "azurerm_user_assigned_identity" "gitActionRunnerIdentity" {
  location            = data.azurerm_resource_group.rg.location
  name                = "${var.user_assigned_identity_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# #can this be achieved here?  role assignments are done by cloud team.
resource "azurerm_role_assignment" "runnerIdentityRole" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.gitActionRunnerIdentity.principal_id
}

resource "azurerm_container_app_job" "containerAppJob" {
  depends_on = [ azurerm_container_registry_task_schedule_run_now.runtask, azurerm_role_assignment.runnerIdentityRole ]
  name                         = "${var.cae_job_name}"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  container_app_environment_id = var.use_existing_cae ? data.azurerm_container_registry.acr.id : azurerm_container_app_environment.containerAppEnv[0].id

  replica_timeout_in_seconds = 1800
  replica_retry_limit        = 0
  registry {
    identity = azurerm_user_assigned_identity.gitActionRunnerIdentity.id
    server = "${var.acr.name}.azurecr.io"
  }
  dynamic "secret" {
    for_each = var.cae_job_secrets
    content {
      name = secret.value.name
      value = secret.value.value
    }
    
  }
  event_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
    scale {
        min_executions = 0
        max_executions = 10
        polling_interval_in_seconds = 30
        rules {
            name = "${var.cae_job_name}"
            custom_rule_type = "github-runner"
            metadata = local.scale_rule_metadata
            # metadata = {
            #   "githubAPIURL": "https://api.github.com",
            #   "owner": "${var.github_owner}",
            #   "repos": "${var.github_repo_name}",
            #   "runnerScope": "${var.runner_scope}",
            #   "applicationID": "${var.GITHUB_APP_ID}",
            #   "installationID": "${var.GITHUB_APP_INSTALLATION_ID}",
            #   "targetWorkflowQueueLength": "1"
            # }
            authentication {
              secret_name = "pem"
              trigger_parameter = "appKey"
              #    --scale-rule-auth "personalAccessToken=personal-access-token" \
              #"appKey=pem" 
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
      image = "${var.acr.name}.azurecr.io/${var.acr_image_repo_name}${var.acr_image_repo_tag == null ? "" : ":${var.acr_image_repo_tag}"}"
      name  = "${var.acr_image_repo_name}"
      dynamic "env" {
        for_each = var.acr_image_env_var
        content {
          name = env.value.name
          value = try(env.value.value, null)
          secret_name = try(env.value.secretRef, null)
        }
      }
      cpu    = 2
      memory = "4Gi"
    }
  }
}
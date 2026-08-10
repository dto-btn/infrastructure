resource "random_password" "litellm_db_password" {
  length           = 24
  special          = true
  override_special = "!#-_" # Avoids characters that cause URL encoding issues
}

resource "azurerm_resource_group" "ssca_cluster" {
  name     = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  location = "canadacentral"
}

data "azurerm_key_vault" "kv" {
  name                = "cio-ect-infra-kv"
  resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
}

resource "azurerm_key_vault_secret" "litellm_db_password" {
  name         = "litellm-db-password"
  value        = random_password.litellm_db_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "litellm_database_url" {
  name         = "litellm-database-url"
  value        = "postgresql://${module.litellm_db.admin_user}:${urlencode(random_password.litellm_db_password.result)}@${module.litellm_db.fqdn}:5432/${module.litellm_db.database_name}?sslmode=require"
  key_vault_id = data.azurerm_key_vault.kv.id
}

module "litellm_db" {
  source = "../../../modules/postgresql-flexible"

  name                   = "ssca-litellm-db"
  resource_group_name    = azurerm_resource_group.ssca_cluster.name
  location               = azurerm_resource_group.ssca_cluster.location
  administrator_login    = "litellmadmin"
  administrator_password = random_password.litellm_db_password.result

  depends_on = [azurerm_resource_group.ssca_cluster]
}

module "litellm_proxy" {
  source = "../../../modules/ssca-cluster"

  resource_group           = azurerm_resource_group.ssca_cluster.name
  create_resource_group    = false
  create_container_app_env = true
  location                 = azurerm_resource_group.ssca_cluster.location
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "litellm-proxy"
      tag       = "1.0.1"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "litellm-proxy"
    revision_mode = "Single"
    target_port   = 4000
    min_replicas  = 1
  }
  subscription_id        = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name  = "SSC-Assistant-Dev"
  unauthenticated_access = true # Set to false for proxy because authentication is handled at the app level

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    "DISABLE_ADMIN_UI"    = "False"
    LITELLM_DEFAULT_MODEL = "azure/gpt-4o"
    LITELLM_JSON_LOGS     = "true"
    LITELLM_LOG           = "INFO"
    UI_USERNAME           = "admin"
    AZURE_OPENAI_VERSION  = "2025-03-01-preview"
    CONFIG_FILE_PATH      = "/app/config/config.dev.yaml"
  }

  secrets = {
    DATABASE_URL          = "litellm-database-url"
    UI_PASSWORD           = "LiteLLM-UI-Password"
    AZURE_OPENAI_ENDPOINT = "Azure-OpenAI-Endpoint"
    LITELLM_MASTER_KEY    = "LiteLLM-Master-Key"
    OPENAI_API_KEY        = "OpenAI-API-Key"
  }

  # Bootstrap dependencies first so secret references resolve before app revision creation.
  depends_on = [
    azurerm_resource_group.ssca_cluster,
    module.litellm_db,
    azurerm_key_vault_secret.litellm_database_url,
  ]
}

locals {
  default_allowed_origins = [
    "http://localhost:8080",
    "https://assistant-dev.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca",
    "https://assistant.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca"
  ]

  container_apps = {
    for app_name, app in var.container_apps :
    app_name => merge(
      app,
      (app_name == "orchestrator" || app_name == "orchestrator_prod") ? {
        env_vars = merge(
          app.env_vars,
          {
            ORCHESTRATOR_LITELLM_PROXY_URL = app_name == "orchestrator_prod" ? "https://${module.litellm_proxy_prod.fqdn}/v1" : "https://${module.litellm_proxy.fqdn}/v1"
          }
        )
      } : {}
    )
  }
}

module "container_apps" {
  for_each = local.container_apps
  source   = "../../../modules/ssca-cluster"

  resource_group           = azurerm_resource_group.ssca_cluster.name
  create_resource_group    = false
  create_container_app_env = each.value.create_container_app_env
  location                 = azurerm_resource_group.ssca_cluster.location

  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = each.value.acr_image.repo_name
      tag       = each.value.acr_image.tag
    }
  }

  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  container_app_environment_name = "ssca-cae"
  container_app                  = each.value.container_app
  subscription_id                = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name          = each.value.container_app.app_registration_name != null ? each.value.container_app.app_registration_name : "SSC-Assistant-Dev"

  allowed_origins = each.value.allowed_origins != null ? each.value.allowed_origins : local.default_allowed_origins

  unauthenticated_access = each.value.unauthenticated_access

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = each.value.env_vars
  secrets  = each.value.secrets

  depends_on = [azurerm_resource_group.ssca_cluster, module.litellm_proxy, module.litellm_proxy_prod]
}

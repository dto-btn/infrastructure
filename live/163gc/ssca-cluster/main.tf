resource "random_password" "litellm_db_password" {
  length           = 24
  special          = true
  override_special = "!#-_" # Avoids characters that cause URL encoding issues
}

module "litellm_db" {
  source = "../../../modules/postgresql-flexible"

  name                   = "ssca-litellm-db"
  resource_group_name    = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  location               = "canadacentral"
  administrator_login    = "litellmadmin"
  administrator_password = random_password.litellm_db_password.result
}

module "litellm_proxy" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = false
  create_container_app_env = false
  location                 = "canadacentral"
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
    "DATABASE_URL"        = "postgresql://${module.litellm_db.admin_user}:${urlencode(module.litellm_db.admin_password)}@${module.litellm_db.fqdn}:5432/${module.litellm_db.database_name}?sslmode=require"
    "DISABLE_ADMIN_UI"    = "False"
    LITELLM_DEFAULT_MODEL = "azure/gpt-4o"
    LITELLM_JSON_LOGS     = "true"
    LITELLM_LOG           = "INFO"
    UI_USERNAME           = "admin"
    DISABLE_ADMIN_UI      = "False"
    AZURE_OPENAI_VERSION  = "2025-03-01-preview"
    CONFIG_FILE_PATH      = "/app/config/config.dev.yaml"
  }

  secrets = {
    UI_PASSWORD           = "LiteLLM-UI-Password"
    AZURE_OPENAI_ENDPOINT = "Azure-OpenAI-Endpoint"
    LITELLM_MASTER_KEY    = "LiteLLM-Master-Key"
    OPENAI_API_KEY        = "OpenAI-API-Key"
  }
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
      app_name == "mcp_server" ? {
        secrets = merge(
          app.secrets,
          {
            ORCHESTRATOR_LITELLM_PROXY_URL = "https://${module.litellm_proxy.fqdn}/v1"
          }
        )
      } : {}
    )
  }
}

moved {
  from = module.dev
  to   = module.container_apps["mcp_server"]
}

moved {
  from = module.geds
  to   = module.container_apps["geds"]
}

moved {
  from = module.pmcoe
  to   = module.container_apps["pmcoe"]
}

moved {
  from = module.myssc
  to   = module.container_apps["myssc"]
}

moved {
  from = module.bits
  to   = module.container_apps["bits"]
}

module "container_apps" {
  for_each = local.container_apps
  source   = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = each.value.create_resource_group
  create_container_app_env = each.value.create_container_app_env
  location                 = "canadacentral"

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
  app_registration_name          = "SSC-Assistant-Dev"

  allowed_origins = each.value.allowed_origins != null ? each.value.allowed_origins : local.default_allowed_origins

  unauthenticated_access = each.value.unauthenticated_access

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = each.value.env_vars
  secrets  = each.value.secrets
}

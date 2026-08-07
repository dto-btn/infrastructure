# Prod copies of litellm_db litellm_proxy and orchestrato
# to be moved to it's own env at a later date.

module "litellm_db_prod" {
  source = "../../../modules/postgresql-flexible"

  name                   = "ssca-litellm-db-prod"
  resource_group_name    = azurerm_resource_group.ssca_cluster.name
  location               = azurerm_resource_group.ssca_cluster.location
  administrator_login    = "litellmadmin"
  administrator_password = random_password.litellm_db_password.result

  depends_on = [azurerm_resource_group.ssca_cluster]
}

module "litellm_proxy_prod" {
  source = "../../../modules/ssca-cluster"

  resource_group           = azurerm_resource_group.ssca_cluster.name
  create_resource_group    = false
  create_container_app_env = false
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
    name          = "litellm-proxy-prod"
    revision_mode = "Single"
    target_port   = 4000
    min_replicas  = 1
  }
  subscription_id        = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name  = "SSC-Assistant"
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
    module.litellm_db_prod,
    azurerm_key_vault_secret.litellm_database_url,
  ]
}



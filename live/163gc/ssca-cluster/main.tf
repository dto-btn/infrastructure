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


module "dev" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = true
  create_container_app_env = true
  location                 = "canadacentral"
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "ssca-mcp-server"
      tag       = "1.0.2"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "ssca-mcp-server"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id       = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"
  allowed_origins       = ["http://localhost:8080", "https://assistant-dev.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca", "https://assistant.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca"]

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    ENABLE_LLM_CLASSIFIER            = "true"
    ORCHESTRATOR_LLM_MODEL           = "gpt-4o"
    ORCHESTRATOR_LLM_TIMEOUT_SECONDS = "8.0"
    GPT40_DEPLOYMENT_NAME            = "gpt-4o"
    DEFAULT_DEPLOYMENT_NAME          = "gpt-4o"
    ORCHESTRATOR_MIN_CONFIDENCE      = "0.4"
    ORCHESTRATOR_ALLOWED_ORIGINS     = "https://assistant-dev.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca,https://assistant.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca"
  }
  secrets = {
    "ORCHESTRATOR_LITELLM_PROXY_URL"     = "https://${module.litellm_proxy.fqdn}/v1"
    "ORCHESTRATOR_LITELLM_PROXY_API_KEY" = "ORCHESTRATOR_LITELLM_PROXY_API_KEY"
    "AZURE_AD_CLIENT_ID"                 = "Azure-AD-Client-ID"
    "AZURE_AD_TENANT_ID"                 = "Azure-AD-Tenant-ID"
    "AZURE_CLIENT_ID"                    = "Azure-Client-ID"
    "AZURE_TENANT_ID"                    = "Azure-Tenant-ID"
  }
}


module "geds" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = false
  create_container_app_env = false
  location                 = "canadacentral"
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "geds-mcp"
      tag       = "1.0.0"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "geds-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id       = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    HOST = "0.0.0.0"
    PORT = "8000"
  }
  secrets = {
    GEDS_API_URL   = "GEDS-API-URL"
    GEDS_API_TOKEN = "GEDS-API-Token"
  }
}


module "pmcoe" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = false
  create_container_app_env = false
  location                 = "canadacentral"
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "azure-search-mcp"
      tag       = "1.0.0"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "pmcoe-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id       = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    AZURE_SEARCH_INDEX_NAME      = "pmcoe-index"
    AZURE_SEARCH_KEY_FIELD       = "chunk_id"
    AZURE_SEARCH_CONTENT_FIELD   = "chunk"
    AZURE_SEARCH_VECTOR_FIELD    = "text_vector"
    AZURE_SEARCH_SEMANTIC_CONFIG = "default-semantic-config"
    MCP_SERVER_NAME              = "PMCOE Search Server"
    HOST                         = "0.0.0.0"
    PORT                         = "8000"
    SEARCH_TOP_RESULTS           = "4"
  }
  secrets = {
    AZURE_SEARCH_SERVICE_ENDPOINT = "Azure-Search-Endpoint"
    AZURE_SEARCH_API_KEY          = "Azure-Search-API-Key"
  }
}


module "myssc" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = false
  create_container_app_env = false
  location                 = "canadacentral"
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "azure-search-mcp"
      tag       = "1.0.0"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "myssc-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id       = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    AZURE_SEARCH_INDEX_NAME      = "myssc-index"
    AZURE_SEARCH_KEY_FIELD       = "id"
    AZURE_SEARCH_CONTENT_FIELD   = "chunk"
    AZURE_SEARCH_SEMANTIC_CONFIG = "mySemanticConfig"
    MCP_SERVER_NAME              = "MySSC+ Search Server"
    HOST                         = "0.0.0.0"
    PORT                         = "8000"
    SEARCH_TOP_RESULTS           = "4"
  }
  secrets = {
    AZURE_SEARCH_SERVICE_ENDPOINT = "Azure-Search-Endpoint"
    AZURE_SEARCH_API_KEY          = "Azure-Search-API-Key"
  }
}


module "bits" {
  source = "../../../modules/ssca-cluster"

  resource_group           = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group    = false
  create_container_app_env = false
  location                 = "canadacentral"
  acr = {
    name                = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "bits-mcp"
      tag       = "1.0.0"
    }
  }
  log_analytics = {
    name                = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "bits-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id       = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  key_vault = {
    name                = "cio-ect-infra-kv"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }

  env_vars = {
    FASTMCP_HOST = "0.0.0.0"
    FASTMCP_PORT = "8000"
  }
  secrets = {
    BITS_DB_DATABASE = "BITS-DB-Name"
    BITS_DB_SERVER   = "BITS-DB-Server"
    BITS_DB_USERNAME = "BITS-DB-Username"
    BITS_DB_PWD      = "BITS-DB-Password"
  }
}

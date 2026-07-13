container_apps = {
  orchestrator = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "ssca-mcp-server"
      revision_mode = "Single"
      min_replicas  = 1
      startup_probe_initial_delay = 1
    }
    acr_image = {
      repo_name = "ssca-mcp-server"
      tag       = "1.0.4"
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
      ORCHESTRATOR_LITELLM_PROXY_API_KEY = "ORCHESTRATOR-LITELLM-PROXY-API-KEY"
      AZURE_AD_CLIENT_ID                 = "Azure-AD-Client-ID"
      AZURE_AD_TENANT_ID                 = "Azure-AD-Tenant-ID"
      AZURE_CLIENT_ID                    = "Azure-Client-ID"
      AZURE_TENANT_ID                    = "Azure-Tenant-ID"
    }
  }

  orchestrator_prod = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "ssca-mcp-server-prod"
      revision_mode = "Single"
      min_replicas  = 1
    }
    acr_image = {
      repo_name = "ssca-mcp-server"
      tag       = "1.0.4"
    }
    env_vars = {
      ENABLE_LLM_CLASSIFIER            = "true"
      ORCHESTRATOR_LLM_MODEL           = "gpt-4o"
      ORCHESTRATOR_LLM_TIMEOUT_SECONDS = "8.0"
      GPT40_DEPLOYMENT_NAME            = "gpt-4o"
      DEFAULT_DEPLOYMENT_NAME          = "gpt-4o"
      ORCHESTRATOR_MIN_CONFIDENCE      = "0.4"
      ORCHESTRATOR_ALLOWED_ORIGINS     = "https://assistant-dev.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca,https://assistant.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca,https://assistant.ssc-spc.gc.ca/"
    }
    secrets = {
      ORCHESTRATOR_LITELLM_PROXY_API_KEY = "ORCHESTRATOR-LITELLM-PROXY-API-KEY"
      AZURE_AD_CLIENT_ID                 = "Azure-AD-Client-ID"
      AZURE_AD_TENANT_ID                 = "Azure-AD-Tenant-ID"
      AZURE_CLIENT_ID                    = "Azure-Client-ID"
      AZURE_TENANT_ID                    = "Azure-Tenant-ID"
    }
  }

  geds = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "geds-mcp"
      revision_mode = "Single"
      min_replicas  = 1
    }
    acr_image = {
      repo_name = "geds-mcp"
      tag       = "1.0.0"
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

  pmcoe = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "pmcoe-mcp"
      revision_mode = "Single"
      min_replicas  = 1
    }
    acr_image = {
      repo_name = "azure-search-mcp"
      tag       = "1.0.0"
    }
    env_vars = {
      AZURE_SEARCH_INDEX_NAME      = "pmcoe-test"
      AZURE_SEARCH_KEY_FIELD       = "chunk_id"
      AZURE_SEARCH_CONTENT_FIELD   = "chunk"
      AZURE_SEARCH_VECTOR_FIELD    = "text_vector"
      AZURE_SEARCH_SEMANTIC_CONFIG = "pmcoe-test-semantic-configuration"
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

  myssc = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "myssc-mcp"
      revision_mode = "Single"
      min_replicas  = 1
      startup_probe_initial_delay = 1
    }
    acr_image = {
      repo_name = "azure-search-mcp"
      tag       = "1.0.0"
    }
    env_vars = {
      AZURE_SEARCH_INDEX_NAME      = "digitaltransformationprocessimprovement"
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

  bits = {
    create_resource_group    = false
    create_container_app_env = false
    container_app = {
      name          = "bits-mcp"
      revision_mode = "Single"
      min_replicas  = 1
    }
    acr_image = {
      repo_name = "bits-mcp"
      tag       = "1.0.0"
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
}
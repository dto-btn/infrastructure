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
    min_replicas = 1
  }
  subscription_id        = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name  = "SSC-Assistant-Dev"
  unauthenticated_access = true # Set to false for proxy because authentication is handled at the app level

  env_vars = merge({
    "DATABASE_URL"     = "postgresql://${module.litellm_db.admin_user}:${urlencode(module.litellm_db.admin_password)}@${module.litellm_db.fqdn}:5432/${module.litellm_db.database_name}?sslmode=require"
    "DISABLE_ADMIN_UI" = "False"
  }, var.litellm_proxy_env_vars)
  
  secrets = var.litellm_proxy_secrets
}


module "dev" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group = true
  create_container_app_env = true
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "ssca-mcp-server"
      tag = "1.0.2"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name = "ssca-mcp-server"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"
  allowed_origins       = ["http://localhost:8080", "https://assistant-dev.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca", "https://assistant.cio-sandbox-ect.ssc-spc.cloud-nuage.canada.ca"]

  env_vars = var.ssca_mcp_env_vars
  secrets  = merge({
    "ORCHESTRATOR_LITELLM_PROXY_URL" = "https://${module.litellm_proxy.fqdn}/v1"
  }, var.ssca_mcp_secrets)
}


module "geds" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group = false
  create_container_app_env = false
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "geds-mcp"
      tag = "1.0.0"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name = "geds-mcp"
    revision_mode = "Single"
    min_replicas = 1
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  env_vars = var.geds_mcp_env_vars
  secrets  = var.geds_mcp_secrets
}


module "pmcoe" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group = false
  create_container_app_env = false
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "azure-search-mcp"
      tag = "1.0.0"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name = "pmcoe-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  env_vars = var.pmcoe_mcp_env_vars
  secrets  = var.pmcoe_mcp_secrets
}


module "myssc" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group = false
  create_container_app_env = false
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "azure-search-mcp"
      tag = "1.0.0"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name = "myssc-mcp"
    revision_mode = "Single"
    min_replicas = 1
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  env_vars = var.myssc_mcp_env_vars
  secrets  = var.myssc_mcp_secrets
}


module "bits" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  create_resource_group = false
  create_container_app_env = false
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "bits-mcp"
      tag = "1.0.0"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name          = "bits-mcp"
    revision_mode = "Single"
    min_replicas  = 1
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registration_name = "SSC-Assistant-Dev"

  env_vars = var.bits_mcp_env_vars
  secrets  = var.bits_mcp_secrets
}

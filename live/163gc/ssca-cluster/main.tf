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
      tag = "1.0"
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
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registation_name = "SSC-Assistant-Dev"
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
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registation_name = "SSC-Assistant-Dev"
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
    name = "azure-search-mcp"
    revision_mode = "Single"
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registation_name = "SSC-Assistant-Dev"
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
  }
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  app_registation_name = "SSC-Assistant-Dev"
}
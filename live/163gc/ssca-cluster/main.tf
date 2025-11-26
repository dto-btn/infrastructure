module "dev" {
  source = "../../../modules/ssca-cluster"

  resource_group = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG"
  location = "canadacentral"
  acr = {
    name = "ectacr"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
    image = {
      repo_name = "ssca-mcp-server"
      tag = "v1"
    }
  }
  log_analytics = {
    name = "ScSc-CIO-ECT-Infra-analytics"
    resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
  }
  container_app_environment_name = "ssca-cae"
  container_app = {
    name = "ssca-cae"
    revision_mode = "Single"
    container_name = "ssca-mcp-server"
  }
}
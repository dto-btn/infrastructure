terraform {
  backend "azurerm" {
    resource_group_name   = "ScSc-CIO_ECT_Infrastructure-rg"
    storage_account_name  = "ectinfra"
    container_name        = "tfstate"
    key                   = "163gc/shared/global/terraform.tfstate"
  }
}
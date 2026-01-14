terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.7.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ScSc-CIO_ECT_Infrastructure-rg"
    storage_account_name = "ectinfra"
    container_name       = "tfstate"
    key                  = "163gc/knowledge-hub/terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {}
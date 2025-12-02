terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.28.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

provider "azapi" {}

provider "azuread" {}
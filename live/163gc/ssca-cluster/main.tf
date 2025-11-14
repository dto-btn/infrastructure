terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.28.0"
    }
  }
}

provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = var.subscription_id
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

# data resource resource_group

resource "azurerm_kubernetes_cluster" "sscacluster" {} 
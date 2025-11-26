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
    subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

data "azurerm_resource_groups" "infrastructureRG" {
  name = "ScSc-CIO_ECT_Infrastructure-rg"
}

resource "azurerm_container_registry" "acr" {
  name                = "dtoacr"
  resource_group_name = data.azurerm_resource_group.infrastructureRG.name
  location            = data.azurerm_resource_group.infrastructureRG.location
  sku                 = "Basic"
  admin_enabled       = false
}
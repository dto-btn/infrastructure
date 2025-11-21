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

data "azurerm_resource_group" "rg" {
    name = var.resource_group
}

output "output" {
  value = "${path.root}"
}
# resource "azurerm_kubernetes_cluster" "sscacluster" {
#   name = "ScSc-CIO_ECT_SSCAssistantCluster"
#   location = data.azurerm_resource_group.rg.location
#   resource_group_name =  data.azurerm_resource_group.rg.name
#   default_node_pool {
#     name = "ssca_nodepool"
#     vm_size = "Standard_D2_v2"
#     auto_scaling_enabled = true
#     # If you're using AutoScaling, you may wish to use Terraform's ignore_changes functionality to ignore changes to the node_count field.

#   }
#   identity {
#     type = "SystemAssigned"
#   }

#   bootstrap_profile {
#     container_registry_id = var.acr_id
#   }

  
# } 
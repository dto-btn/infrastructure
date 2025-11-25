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

//this to change if aurora takes over.  Won't have this rg
//If we keep container apps, then move into ssca rg?
resource "azurerm_resource_group" "rg" {
    name = "ScSc-CIO-ECT_SSCA_Cluster_Dev_RG" 
    location = "canadacentral"
}

//change this to reference from terraform_remote_state output from shared
data "azurerm_container_registry" "acr" {
  name                = "dtoacr"
  resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
}

data "azurerm_log_analytics_workspace" "logAnalytics" {
  name = "ScSc-CIO-ECT-Infra-analytics"
  resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
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
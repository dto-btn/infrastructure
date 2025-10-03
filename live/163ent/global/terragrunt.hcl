terraform {
    source = "../../../modules//global"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}

inputs = {
   resource_group_name = "G3Pc-SSC_CIOAssistant_Project-rg"
   name_prefix = "G3Pc-SSC_CIOAssistant"
   acr_name = "cioassistantacr"
   tenant_id = "7198d08c-c362-4703-9854-53b6f0d8fc44"  #this should be elsewhere.
}

remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "GcDc-CTO_RPA_Project-rg"
        storage_account_name = "gcdaaconfig"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = "e04326a7-a0a1-4c57-9a29-b8c431d14d35" #this to be placed elsewhere after
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}
variable "subscription_id" {}

provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = var.subscription_id
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

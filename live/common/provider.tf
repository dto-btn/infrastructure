provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8" #this to be placed elsewhere after
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

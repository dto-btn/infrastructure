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

locals {
  permissions = {
    for a in var.permissions :
    a.name => a
  }

  group_principals = {
    for a in var.permissions : a.principal_name => a
    if a.principal_type == "group"
  }

  user_principals = {
    for a in var.permissions : a.principal_name => a
    if a.principal_type == "user"
  }

  role_definitions = {
    for a in var.permissions :
    "${a.role_definition}|${a.scope_id}" => a
  }

}

# idea is a for_each on the local variable and create role assignments off that.
# resource "azurerm_role_assignment" "roleAssignments" {
#   scope = "requiredattr"
#   principal_id = "requiredattr"
# }

#temporary. to see what objects look like after locals block.
output "group" {
  value = local.group_principals
}
output "user" {
  value = local.user_principals
}
output "role" {
  value = local.role_definitions
}
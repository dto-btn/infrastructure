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

# custom role may get too complicated for our needs.  use built-in for now.  just loop through var
locals {

  assignments = {
    for a in var.permissions : "${a.principal_name}_${a.role_definition}_${a.scope_id}" => a
  }

#   group_principals = {
#     for a in var.permissions : a.principal_name => a...
#     if a.principal_type == "group"
#   }

#   user_principals = {
#     for a in var.permissions : a.principal_name => a...
#     if a.principal_type == "user"
#   }

#   #Unique role + scope pairing that needs to be defined
#   role_definitions = {
#     for a in var.permissions :
#     "${a.role_definition}|${a.scope_id}" => a...
#   }
}

#temporary. to see what objects look like after locals block.
# output "group" {
#   value = local.group_principals
# }
# output "user" {
#   value = local.user_principals
# }
# output "role" {
#   value = local.role_definitions
# }
output "assignments" {
  value = local.assignments
}

# idea is a for_each on the local variable and create role assignments off that.
resource "azurerm_role_assignment" "roleAssignments" {
  for_each = local.assignments

  principal_id = each.value.principal_name
  scope = each.value.scope_id
  role_definition_name = each.value.role_definition
}
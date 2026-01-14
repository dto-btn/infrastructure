resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = "Canada Central"
}

resource "azurerm_storage_account" "hub" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_container" "public" {
  name                  = var.public_container_name
  storage_account_name    = azurerm_storage_account.hub.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "private" {
  name                  = var.private_container_name
  storage_account_name    = azurerm_storage_account.hub.name
  container_access_type = "private"
}

data "azuread_user" "private_access" {
  for_each = toset(var.private_container_emails)

  user_principal_name = each.value
}

resource "azurerm_role_assignment" "private_rw" {
  for_each = data.azuread_user.private_access

  scope                = azurerm_storage_container.private.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value.object_id
}

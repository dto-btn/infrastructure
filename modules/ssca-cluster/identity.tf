resource "azurerm_user_assigned_identity" "mcpImageIdentity" {
  location            = local.rg_location
  name                = "${var.container_app.name}_CA-${var.acr.name}_acr-identity"
  resource_group_name = local.rg_name
}

resource "azurerm_role_assignment" "mcpImageIdentityRoleACRPull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.mcpImageIdentity.principal_id
}

resource "azurerm_role_assignment" "container_app_kv_reader" {
  count                = var.key_vault != null ? 1 : 0
  scope                = data.azurerm_key_vault.kv[0].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.mcpImageIdentity.principal_id
}

# Required when the Key Vault uses Access Policy authorization (enableRbacAuthorization = false).
# The RBAC role assignment above has no effect in that mode.
resource "azurerm_key_vault_access_policy" "container_app_kv_policy" {
  count        = var.key_vault != null ? 1 : 0
  key_vault_id = data.azurerm_key_vault.kv[0].id
  tenant_id    = azurerm_user_assigned_identity.mcpImageIdentity.tenant_id
  object_id    = azurerm_user_assigned_identity.mcpImageIdentity.principal_id

  secret_permissions = ["Get", "List"]
}
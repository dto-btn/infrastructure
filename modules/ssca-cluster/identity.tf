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
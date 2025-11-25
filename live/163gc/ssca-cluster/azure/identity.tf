resource "azurerm_user_assigned_identity" "mcpImageIdentity" {
  location            = azurerm_resource_group.rg.location
  name                = "mcp-image-identity"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "runnerIdentityRoleACRPull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.mcpImageIdentity.principal_id
}
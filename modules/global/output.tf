output "key_vault_name" {
    value = azurerm_key_vault.infrakv.name
}

output "key_vault_id" {
    value = azurerm_key_vault.infrakv.id
}
output "resource_group_name" {
    value = azurerm_key_vault.infrakv.resource_group_name
}

output "resource_group_id" {
    value = data.azurerm_resource_group.rg.id
}

output "acr_name" {
    value = azurerm_container_registry.acr.name
}

output "log_analytics_workspace_name" {
    value = azurerm_log_analytics_workspace.logAnalytics.name
}
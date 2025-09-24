output "key_vault_name" {
    value = azurerm_key_vault.infrakv.name
}

output "acr_name" {
    value = azurerm_container_registry.acr.name
}

output "log_analytics_workspace_name" {
    value = azurerm_log_analytics_workspace.logAnalytics.name
}
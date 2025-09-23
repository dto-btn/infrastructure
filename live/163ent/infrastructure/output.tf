output "key_vault_name" {
    value = azurerm_key_vault.infrakv.name
}

output "acr_name" {
    value = azurerm_container_registry.acr.name
}
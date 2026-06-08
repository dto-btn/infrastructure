output "fqdn" {
  value = azurerm_container_app.containerApp.latest_revision_fqdn
}

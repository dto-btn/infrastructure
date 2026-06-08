output "fqdn" { value = azurerm_postgresql_flexible_server.server.fqdn }
output "admin_user" { value = azurerm_postgresql_flexible_server.server.administrator_login }
output "database_name" { value = azurerm_postgresql_flexible_server_database.db.name }

output "server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.database.name
}

output "server_fqdn" {
  description = "PostgreSQL server DNS name"
  value       = azurerm_postgresql_flexible_server.database.fqdn
}

output "server_id" {
  description = "Azure resource ID of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.database.id
}
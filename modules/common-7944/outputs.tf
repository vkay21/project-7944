output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.logs.name
}

output "recovery_services_vault_name" {
  value = azurerm_recovery_services_vault.vault.name
}

output "storage_account_name" {
  value = azurerm_storage_account.diagnostics.name
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.diagnostics.primary_blob_endpoint
}
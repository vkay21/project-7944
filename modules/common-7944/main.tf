resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.prefix}-LAW"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "rsv-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.recovery_vault_sku
  storage_mode_type   = "LocallyRedundant"
  tags                = var.tags
}

resource "azurerm_storage_account" "diagnostics" {
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false

  tags = var.tags
}
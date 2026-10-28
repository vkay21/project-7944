variable "resource_group_name" {
  description = "Resource group for common services"
  type        = string
}

variable "location" {
  description = "Azure region for common services"
  type        = string
}

variable "prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique storage account name"
  type        = string
}

variable "log_analytics_sku" {
  description = "Pricing tier for the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Log Analytics data retention in days"
  type        = number
  default     = 30
}

variable "recovery_vault_sku" {
  description = "Recovery Services vault pricing tier"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags applied to common services"
  type        = map(string)
}
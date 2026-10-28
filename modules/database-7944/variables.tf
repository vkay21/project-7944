variable "resource_group_name" {
  description = "Resource group containing the PostgreSQL server"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "Globally unique PostgreSQL server name"
  type        = string
}

variable "administrator_login" {
  description = "PostgreSQL administrator username"
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "postgresql_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "16"
}

variable "sku_name" {
  description = "PostgreSQL compute SKU"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Allocated database storage in MB"
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to the PostgreSQL server"
  type        = map(string)
}
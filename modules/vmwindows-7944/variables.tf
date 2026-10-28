variable "resource_group_name" {
  description = "Resource group containing the Windows resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "subnet_id" {
  description = "Subnet for Windows network interfaces"
  type        = string
}

variable "vm_count" {
  description = "Number of Windows VMs"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Azure Windows VM size"
  type        = string
}

variable "admin_username" {
  description = "Windows administrator username"
  type        = string
}

variable "admin_password" {
  description = "Windows administrator password"
  type        = string
  sensitive   = true
}

variable "dns_label_prefix" {
  description = "Prefix for unique public DNS labels"
  type        = string
}

variable "boot_diagnostics_storage_uri" {
  description = "Blob endpoint for VM boot diagnostics"
  type        = string
}

variable "image" {
  description = "Windows Server Marketplace image"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "tags" {
  description = "Tags applied to supported Windows resources"
  type        = map(string)
}
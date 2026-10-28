variable "resource_group_name" {
  description = "Resource group containing the data disks"
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

variable "virtual_machines" {
  description = "VM IDs and zones for data disk placement"
  type = map(object({
    vm_id = string
    zone  = optional(string)
  }))
}

variable "disk_size_gb" {
  description = "Size of each data disk in GB"
  type        = number
  default     = 10
}

variable "storage_account_type" {
  description = "Managed disk storage SKU"
  type        = string
  default     = "Standard_LRS"
}

variable "tags" {
  description = "Tags applied to the data disks"
  type        = map(string)
}
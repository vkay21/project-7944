variable "resource_group_name" {
  type        = string
  description = "Resource group containing the Linux VMs"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "prefix" {
  type        = string
  description = "Resource naming prefix"
}

variable "subnet_id" {
  type        = string
  description = "Subnet for the VM network interfaces"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size"
}

variable "admin_username" {
  type        = string
  description = "Administrator username for the Linux VMs"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Local path to the SSH public key"
}

variable "boot_diagnostics_storage_uri" {
  type        = string
  description = "Blob endpoint of the diagnostics storage account"
}

variable "image" {
  description = "Azure Marketplace image for the Linux VMs"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to supported resources"
}

variable "linux_vms" {
  description = "Linux VM names and their availability zones"
  type = map(object({
    zone      = string
    dns_label = string
  }))
}

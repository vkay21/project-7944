variable "resource_group_name" {
  description = "Resource group containing the network"
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

variable "vnet_address_space" {
  description = "Address ranges for the virtual network"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Address ranges for the subnet"
  type        = list(string)
}

variable "admin_source_cidr" {
  description = "Public IPv4 CIDR allowed to access management ports"
  type        = string
}

variable "tags" {
  description = "Tags applied to supported network resources"
  type        = map(string)
}
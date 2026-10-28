variable "resource_group_name" {
  description = "Resource group containing the load balancer"
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

variable "network_interface_ids" {
  description = "Map of Linux VM names to network interface IDs"
  type        = map(string)
}

variable "frontend_port" {
  description = "Port clients use to reach the load balancer"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Web server port on the Linux VMs"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags applied to supported load balancer resources"
  type        = map(string)
}
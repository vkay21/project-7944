output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.subnet.name
}

output "subnet_id" {
  description = "Subnet ID used to connect VM network interfaces"
  value       = azurerm_subnet.subnet.id
}
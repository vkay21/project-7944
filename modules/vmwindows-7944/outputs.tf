output "hostnames" {
  description = "Windows computer names"
  value       = azurerm_windows_virtual_machine.windows[*].computer_name
}

output "fqdns" {
  description = "Public DNS names of the Windows VMs"
  value       = azurerm_public_ip.windows[*].fqdn
}

output "private_ip_addresses" {
  description = "Windows private IP addresses"
  value       = azurerm_network_interface.windows[*].private_ip_address
}

output "public_ip_addresses" {
  description = "Windows public IP addresses"
  value       = azurerm_public_ip.windows[*].ip_address
}

output "vm_ids" {
  description = "Windows VM IDs for data disk attachments"
  value       = azurerm_windows_virtual_machine.windows[*].id
}

output "availability_set_name" {
  description = "Name of the Windows availability set"
  value       = azurerm_availability_set.windows.name
}
output "resource_group_name" {
  description = "Name of the project resource group"
  value       = module.rgroup.resource_group_name
}
output "vnet_name" {
  description = "Name of the project virtual network"
  value       = module.network.vnet_name
}

output "subnet_name" {
  description = "Name of the project subnet"
  value       = module.network.subnet_name
}

output "log_analytics_workspace_name" {
  value = module.common.log_analytics_workspace_name
}

output "recovery_services_vault_name" {
  value = module.common.recovery_services_vault_name
}

output "diagnostics_storage_account_name" {
  value = module.common.storage_account_name
}

output "linux_hostnames" {
  value = module.vmlinux.hostnames
}

output "linux_fqdns" {
  value = module.vmlinux.fqdns
}

output "linux_private_ip_addresses" {
  value = module.vmlinux.private_ip_addresses
}

output "linux_public_ip_addresses" {
  value = module.vmlinux.public_ip_addresses
}
output "windows_hostnames" {
  value = module.vmwindows.hostnames
}

output "windows_fqdns" {
  value = module.vmwindows.fqdns
}

output "windows_private_ip_addresses" {
  value = module.vmwindows.private_ip_addresses
}

output "windows_public_ip_addresses" {
  value = module.vmwindows.public_ip_addresses
}

output "windows_availability_set_name" {
  value = module.vmwindows.availability_set_name
}
output "data_disk_names" {
  value = module.datadisk.disk_names
}
output "load_balancer_name" {
  value = module.loadbalancer.load_balancer_name
}

output "load_balancer_public_ip" {
  value = module.loadbalancer.public_ip_address
}

output "web_url" {
  value = module.loadbalancer.web_url
}
output "postgresql_server_name" {
  value = module.database.server_name
}

output "postgresql_server_fqdn" {
  value = module.database.server_fqdn
}
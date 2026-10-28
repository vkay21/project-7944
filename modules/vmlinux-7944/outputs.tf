output "hostnames" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux :
    key => vm.computer_name
  }
}

output "fqdns" {
  value = {
    for key, ip in azurerm_public_ip.linux :
    key => ip.fqdn
  }
}

output "private_ip_addresses" {
  value = {
    for key, nic in azurerm_network_interface.linux :
    key => nic.private_ip_address
  }
}

output "public_ip_addresses" {
  value = {
    for key, ip in azurerm_public_ip.linux :
    key => ip.ip_address
  }
}

output "vm_ids" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux :
    key => vm.id
  }
}

output "network_interface_ids" {
  value = {
    for key, nic in azurerm_network_interface.linux :
    key => nic.id
  }
}

output "vm_zones" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux :
    key => vm.zone
  }
}
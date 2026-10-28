resource "azurerm_public_ip" "linux" {
  for_each = var.linux_vms

  name                = "${var.prefix}-${each.key}-PIP"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = [each.value.zone]
  domain_name_label = each.value.dns_label

  tags = var.tags
}

resource "azurerm_network_interface" "linux" {
  for_each = var.linux_vms

  name                = "${var.prefix}-${each.key}-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux[each.key].id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linux" {
  for_each = var.linux_vms

  name                = "${var.prefix}-${each.key}"
  computer_name       = "${var.prefix}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  size = var.vm_size
  zone = each.value.zone

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.linux[each.key].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  disk_controller_type = "NVMe"

  custom_data = base64encode(<<-SCRIPT
    #!/bin/bash
    set -eu
    export DEBIAN_FRONTEND=noninteractive

    apt-get -o Acquire::Retries=5 update
    apt-get -o Acquire::Retries=5 -o DPkg::Lock::Timeout=300 install -y nginx curl

    printf '<h1>CCGC 5502 Terraform Project</h1><p>Server: %s</p>\n' "$(hostname)" > /var/www/html/index.html

    systemctl enable nginx
    systemctl restart nginx
  SCRIPT
  )

  os_disk {
    name                 = "${var.prefix}-${each.key}-OSDISK"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each = var.linux_vms

  name                       = "${var.prefix}-${each.key}-NetworkWatcher"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each = var.linux_vms

  name                       = "${var.prefix}-${each.key}-AzureMonitor"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true

  tags = var.tags
}
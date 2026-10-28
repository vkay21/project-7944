resource "azurerm_availability_set" "windows" {
  name                = "${var.prefix}-windows-AVSET"
  location            = var.location
  resource_group_name = var.resource_group_name

  managed                      = true
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5

  tags = var.tags
}

resource "azurerm_public_ip" "windows" {
  count = var.vm_count

  name                = "${var.prefix}-win${count.index + 1}-PIP"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  domain_name_label = "${var.dns_label_prefix}-${count.index + 1}"

  tags = var.tags
}

resource "azurerm_network_interface" "windows" {
  count = var.vm_count

  name                = "${var.prefix}-win${count.index + 1}-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows[count.index].id
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "windows" {
  count = var.vm_count

  name                = "${var.prefix}-win${count.index + 1}"
  computer_name       = "${var.prefix}-win${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.windows.id

  network_interface_ids = [
    azurerm_network_interface.windows[count.index].id
  ]

  provision_vm_agent        = true
  automatic_updates_enabled = true
  disk_controller_type      = "NVMe"

  os_disk {
    name                 = "${var.prefix}-win${count.index + 1}-OSDISK"
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

  tags = var.tags
}
resource "azurerm_virtual_machine_extension" "antimalware" {
  count = var.vm_count

  name                       = "${var.prefix}-win${count.index + 1}-Antimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    AntimalwareEnabled        = true
    RealtimeProtectionEnabled = true
  })

  tags = var.tags
}
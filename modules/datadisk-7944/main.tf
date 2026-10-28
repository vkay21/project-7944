resource "azurerm_managed_disk" "data" {
  for_each = var.virtual_machines

  name                 = "${var.prefix}-${each.key}-DATA"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  zone                 = each.value.zone

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = var.virtual_machines

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = each.value.vm_id
  lun                = 0
  caching            = "None"
}
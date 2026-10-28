output "disk_names" {
  description = "Names of the VM data disks"
  value = {
    for key, disk in azurerm_managed_disk.data :
    key => disk.name
  }
}

output "disk_ids" {
  description = "IDs of the VM data disks"
  value = {
    for key, disk in azurerm_managed_disk.data :
    key => disk.id
  }
}
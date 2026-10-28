resource "null_resource" "linux_hostname" {
  for_each = var.linux_vms

  triggers = {
    vm_id     = azurerm_linux_virtual_machine.linux[each.key].id
    public_ip = azurerm_public_ip.linux[each.key].ip_address
  }

  connection {
    type    = "ssh"
    host    = azurerm_public_ip.linux[each.key].ip_address
    user    = var.admin_username
    agent   = true
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo cloud-init status --wait",
      "hostname",
      "curl --fail --silent --show-error http://localhost/"
    ]
  }
}
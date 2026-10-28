output "load_balancer_name" {
  value = azurerm_lb.public.name
}

output "public_ip_address" {
  value = azurerm_public_ip.lb.ip_address
}

output "web_url" {
  value = "http://${azurerm_public_ip.lb.ip_address}:${var.frontend_port}"
}
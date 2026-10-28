resource "azurerm_public_ip" "lb" {
  name                = "${var.prefix}-LB-PIP"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

resource "azurerm_lb" "public" {
  name                = "${var.prefix}-LB"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "linux" {
  name            = "${var.prefix}-linux-pool"
  loadbalancer_id = azurerm_lb.public.id
}

resource "azurerm_network_interface_backend_address_pool_association" "linux" {
  for_each = var.network_interface_ids

  network_interface_id    = each.value
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.linux.id
}

resource "azurerm_lb_probe" "http" {
  name            = "${var.prefix}-http-probe"
  loadbalancer_id = azurerm_lb.public.id

  protocol            = "Http"
  port                = var.backend_port
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http" {
  name            = "${var.prefix}-http-rule"
  loadbalancer_id = azurerm_lb.public.id

  protocol      = "Tcp"
  frontend_port = var.frontend_port
  backend_port  = var.backend_port

  frontend_ip_configuration_name = "public-frontend"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.linux.id
  ]
  probe_id = azurerm_lb_probe.http.id

  disable_outbound_snat = true
}
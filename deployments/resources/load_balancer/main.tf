variable "prefix" {
}
variable "location" {
}
variable "resource_group_name" {
}
variable "subnet_id" {
}
variable "zones" {
}
variable "network_interfaces" {
}
variable "private_ip_address" {
}
variable "tags" {}




resource "azurerm_lb" "load_balancer" {
  name                = "${var.prefix}-LoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "load_balancer_ip"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
    subnet_id                     = var.subnet_id
    zones                         = var.zones
  }
  tags = { user: var.tags.user }
}

resource "azurerm_lb_probe" "pfmp_probe" {
  loadbalancer_id     = azurerm_lb.load_balancer.id
  name                = "pfmp-probe"
  port                = 30400
  interval_in_seconds = 5
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "production-inbound-rules" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "pfmp-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 30400
  frontend_ip_configuration_name = "load_balancer_ip"
  probe_id                       = azurerm_lb_probe.pfmp_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_be_pool.id]

}

resource "azurerm_lb_backend_address_pool" "lb_be_pool" {
  name            = "pfmp_pool"
  loadbalancer_id = azurerm_lb.load_balancer.id
}


resource "azurerm_network_interface_backend_address_pool_association" "lb_be_pool_association" {
  count                   = 3
  network_interface_id    = var.network_interfaces[count.index].id
  ip_configuration_name   = var.network_interfaces[count.index].ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_be_pool.id
}

output "pfmp_ips" {
  value = [var.network_interfaces[0].ip_configuration.0.private_ip_address,
    var.network_interfaces[1].ip_configuration.0.private_ip_address,
  var.network_interfaces[2].ip_configuration.0.private_ip_address]
}
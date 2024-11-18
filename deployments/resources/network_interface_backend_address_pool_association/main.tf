### This module is used only by small deployment

variable "cluster_nics" {
}
variable "lb_be_address_pool_id" {
}


resource "azurerm_network_interface_backend_address_pool_association" "lb_be_pool_association" {
  count                   = 3
  network_interface_id    = var.cluster_nics[count.index].id
  ip_configuration_name   = var.cluster_nics[count.index].ip_configuration.0.name
  backend_address_pool_id = var.lb_be_address_pool_id
}
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
variable "tags" {}




resource "azurerm_public_ip" "nat_gateway_public_ip" {
  name                = "${var.prefix}-nat-gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [element(var.zones, 0)]
}

resource "azurerm_public_ip_prefix" "nat_gateway_public_ip_prefix" {
  name                = "${var.prefix}-nat-gateway-public-ip-prefix"
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = 31
  zones               = [element(var.zones, 0)]
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.prefix}-nat-gateway"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [element(var.zones, 0)]
  tags = { user: var.tags.user }
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_public_ip.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gateway_public_ip_prefix_association" {
  nat_gateway_id      = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.nat_gateway_public_ip_prefix.id
}

resource "azurerm_subnet_nat_gateway_association" "exampsubnet_nat_gateway_associationle" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
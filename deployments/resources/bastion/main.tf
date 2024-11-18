variable "prefix" {
}
variable "location" {
}
variable "resource_group_name" {
}
variable "subnet_id" {
}
variable "tags" {}


resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${var.prefix}-bastion-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard" #https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses
}

resource "azurerm_bastion_host" "app_bastion" {
  name                = "${var.prefix}-app-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  tunneling_enabled   = true # needed but deployment fails when set to True. Manually set "native client support"

  sku = "Standard"

  ip_configuration {
    name                 = "bastion-configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
  tags = { user: var.tags.user }
}
variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "prefix" {}
variable "vnet_cidr_range" {}
variable "pods_cidr_range" {}
variable "tags" {}


resource "azurerm_network_security_group" "cluster_nsg" {
  name                = "${var.prefix}-cluster-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.nsg_rules_vnet
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_address_prefix      = var.vnet_cidr_range
      source_port_range          = security_rule.value.source_port_range
      destination_address_prefix = security_rule.value.destination_address_prefix
      destination_port_range     = security_rule.value.destination_port_range
    }
  }

    dynamic "security_rule" {
    for_each = var.nsg_rules_pods
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_address_prefix      = var.pods_cidr_range
      source_port_range          = security_rule.value.source_port_range
      destination_address_prefix = security_rule.value.destination_address_prefix
      destination_port_range     = security_rule.value.destination_port_range
    }
  }

    dynamic "security_rule" {
      for_each = var.nsg_rules_with_fixed_source
      content {
        name                       = security_rule.value.name
        priority                   = security_rule.value.priority
        direction                  = security_rule.value.direction
        access                     = security_rule.value.access
        protocol                   = security_rule.value.protocol
        source_address_prefix      = security_rule.value.source_address_prefix
        source_port_range          = security_rule.value.source_port_range
        destination_address_prefix = security_rule.value.destination_address_prefix
        destination_port_range     = security_rule.value.destination_port_range
      }
  }

  tags = { user: var.tags.user }
}

resource "azurerm_subnet_network_security_group_association" "cluster_nsg_association" {
  network_security_group_id = azurerm_network_security_group.cluster_nsg.id
  subnet_id                 = var.subnet_id
}
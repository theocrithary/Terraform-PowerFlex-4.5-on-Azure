variable "resource_group_name" {}
variable "prefix" {}
variable "address_space" {}
variable "subnet_prefixes" {}
variable "subnet_names" {}
variable "location" {}
variable "tags" {}




module "vnet-main" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 3.0"
  resource_group_name = var.resource_group_name
  vnet_name           = "${var.prefix}-main-vnet"
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  nsg_ids             = {}
  vnet_location       = var.location
  tags = { user: var.tags.user }
}

output "subnet_ids" {
  value = module.vnet-main.vnet_subnets
}
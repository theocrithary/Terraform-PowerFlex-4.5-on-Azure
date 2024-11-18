terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

data "azurerm_shared_image" "pflex_ami" {
  name                = var.pflex_shared_image.name
  gallery_name        = var.pflex_shared_image.gallery_name
  resource_group_name = var.pflex_shared_image.resource_group_name
}

data "azurerm_shared_image" "installer_ami" {
  name                = var.installer_shared_image.name
  gallery_name        = var.installer_shared_image.gallery_name
  resource_group_name = var.installer_shared_image.resource_group_name
}

locals {
  zones = var.is_multi_az ? var.availability_zones : [element(var.availability_zones, 0)]
}

module "resource_group" {
  source   = "../resources/resource_group"
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

module "virtual_network" {
  source              = "../resources/virtual_network"
  resource_group_name = module.resource_group.name
  location            = var.location
  prefix              = var.prefix
  address_space       = [var.vnet_cidr_range]
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  tags                = var.tags
}

module "network_security_group" {
  source              = "../resources/network_security_group"
  name                = "${var.prefix}-cluster-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name
  prefix              = var.prefix
  subnet_id           = module.virtual_network.subnet_ids[0]
  vnet_cidr_range     = var.vnet_cidr_range
  pods_cidr_range     = var.pods_cidr_range
  tags                = var.tags
}

module "cluster_node" {
  source                              = "../resources/cluster_node"
  cluster_node_count                  = var.cluster_node_count
  prefix                              = var.prefix
  location                            = var.location
  resource_group_name                 = module.resource_group.name
  vm_size                             = var.vm_size.pflex
  zones                               = local.zones
  os_disk_size_gb                     = var.os_disk_size_gb.pflex
  source_image_id                     = data.azurerm_shared_image.pflex_ami.id
  pflex_enable_accelerated_networking = var.pflex_enable_accelerated_networking
  pflex_enable_ip_forwarding          = var.pflex_enable_ip_forwarding
  subnet_id                           = module.virtual_network.subnet_ids[0]
  use_ssh_keys                        = var.use_ssh_keys
  public_key_path                     = var.public_key_path
  tags                                = var.tags
}

module "installer_node" {
  source                 = "../resources/installer_node"
  prefix                 = var.prefix
  location               = var.location
  resource_group_name    = module.resource_group.name
  vm_size                = var.vm_size.installer
  zones                  = local.zones
  os_disk_size_gb        = var.os_disk_size_gb.installer
  # source_image_reference = var.source_image_reference.installer
  source_image_id        = data.azurerm_shared_image.installer_ami.id
  subnet_id              = module.virtual_network.subnet_ids[0]
  public_key_path        = var.public_key_path
  tags                   = var.tags
}

module "jumphost_node" {
  source                 = "../resources/jumphost_node"
  prefix                 = var.prefix
  location               = var.location
  resource_group_name    = module.resource_group.name
  vm_size                = var.vm_size.jumphost
  zones                  = local.zones
  source_image_reference = var.source_image_reference.jumphost
  subnet_id              = module.virtual_network.subnet_ids[0]
  tags                   = var.tags
}

module "bastion" {
  source              = "../resources/bastion"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.virtual_network.subnet_ids[1]
  tags                = var.tags
}

module "load_balancer" {
  source              = "../resources/load_balancer"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.virtual_network.subnet_ids[0]
  zones               = local.zones
  network_interfaces  = module.cluster_node.cluster_nics
  private_ip_address  = var.lb_private_ip_address
  tags                = var.tags
}

module "nat_gateway" {
  source              = "../resources/nat_gateway"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.virtual_network.subnet_ids[0]
  zones               = local.zones
  tags                = var.tags
}

output "resource_group_name" {
  value = module.resource_group.name
}

output "pfmp_os_disk_names" {
  value = module.cluster_node.pfmp_os_disk_names
}

output "pfmp_private_ips" {
  value = module.cluster_node.pfmp_private_ips
}

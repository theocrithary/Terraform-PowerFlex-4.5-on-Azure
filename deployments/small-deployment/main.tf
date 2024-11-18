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

locals {
  zones = var.is_multi_az ? var.availability_zones : [element(var.availability_zones, 0)]
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "default_subnet" {
  name                 = var.default_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_lb" "lb" {
  name                = var.load_balancer_name
  resource_group_name = var.resource_group_name
}

data "azurerm_lb_backend_address_pool" "lb_be_pool" {
  name            = var.lb_be_address_pool_name
  loadbalancer_id = data.azurerm_lb.lb.id
}

module "managed_disk" {
  source                    = "../resources/managed_disk"
  data_disk_count           = var.data_disk_count
  cluster_node_count        = var.cluster_node_count
  location                  = var.location
  prefix                    = var.prefix
  availability_zones        = local.zones
  resource_group_name       = var.resource_group_name
  data_storage_account_type = var.data_storage_account_type
  data_disk_size_gb         = var.data_disk_size_gb
  cluster_node_ids          = module.cluster_node.cluster_node_ids
  data_disk_mbps_read_write = var.data_disk_mbps_read_write
  data_disk_iops_read_write = var.data_disk_iops_read_write
  tags                      = var.tags
}

module "cluster_node" {
  source                              = "../resources/cluster_node"
  cluster_node_count                  = var.cluster_node_count
  prefix                              = var.prefix
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  vm_size                             = var.vm_size.pflex
  zones                               = local.zones
  os_disk_size_gb                     = var.os_disk_size_gb.pflex
  source_image_id                     = data.azurerm_shared_image.pflex_ami.id
  pflex_enable_accelerated_networking = var.pflex_enable_accelerated_networking
  pflex_enable_ip_forwarding          = var.pflex_enable_ip_forwarding
  subnet_id                           = data.azurerm_subnet.default_subnet.id
  use_ssh_keys                        = var.use_ssh_keys
  public_key_path                     = var.public_key_path
  tags                                = var.tags
}

module "network_interface_backend_address_pool_association" {
  source                = "../resources/network_interface_backend_address_pool_association"
  cluster_nics          = module.cluster_node.cluster_nics
  lb_be_address_pool_id = data.azurerm_lb_backend_address_pool.lb_be_pool.id
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "pfmp_os_disk_names" {
  value = module.cluster_node.pfmp_os_disk_names
}

output "pfmp_private_ips" {
  value = module.cluster_node.pfmp_private_ips
}

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

locals {
  zones = var.is_multi_az ? var.availability_zones : [element(var.availability_zones, 0)]
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_virtual_machine" "vm" {
  count = var.cluster_node_count
  name                = "${var.virtual_machine_prefix}-${count.index}"
  resource_group_name = var.resource_group_name
}


resource "azurerm_managed_disk" "data_disks" {
  count                = var.data_disk_count * var.cluster_node_count
  name                 = "${var.prefix}-data-disk-${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.data_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
  zone                 = var.availability_zones[floor(count.index / var.data_disk_count) % length(var.availability_zones)]
  # zone = "1"
  disk_iops_read_write = var.data_disk_iops_read_write #set only for ultra and SSDv2 disks
  disk_mbps_read_write = var.data_disk_mbps_read_write #set only for ultra and SSDv2 disks
  tags = { user: var.tags.user }
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  count              = var.data_disk_count * var.cluster_node_count
  managed_disk_id    = azurerm_managed_disk.data_disks[count.index].id
  virtual_machine_id = data.azurerm_virtual_machine.vm[floor(count.index / var.data_disk_count)].id
  lun                = var.start_from_lun > 0 ? (count.index % var.data_disk_count) + var.start_from_lun : (count.index % var.data_disk_count)
  caching            = "None"
}

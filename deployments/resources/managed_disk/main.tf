variable "location" {}
variable "resource_group_name" {}
variable "data_storage_account_type" {}
variable "data_disk_size_gb" {}
variable "data_disk_count" {}
variable "cluster_node_count" {}
variable "availability_zones" {}
variable "cluster_node_ids" {}
variable "data_disk_iops_read_write" {}
variable "data_disk_mbps_read_write" {}
variable "prefix" {}
variable "tags" {}


resource "azurerm_managed_disk" "data_disks" {
  count                = var.data_disk_count * var.cluster_node_count
  name                 = "${var.prefix}-data-disk-${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.data_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
  zone                 = var.availability_zones[floor(count.index / var.data_disk_count) % length(var.availability_zones)]
  disk_iops_read_write = var.data_disk_iops_read_write #set only for ultra and SSDv2 disks
  disk_mbps_read_write = var.data_disk_mbps_read_write #set only for ultra and SSDv2 disks
  logical_sector_size  = 512
  tags = { user: var.tags.user }
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  count              = var.data_disk_count * var.cluster_node_count
  managed_disk_id    = azurerm_managed_disk.data_disks[count.index].id
  virtual_machine_id = var.cluster_node_ids[floor(count.index / var.data_disk_count)]
  lun                = count.index % var.data_disk_count
  caching            = "None"
}

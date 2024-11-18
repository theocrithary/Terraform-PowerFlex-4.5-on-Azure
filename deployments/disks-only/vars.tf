variable "cluster_node_count" {
  type    = number
  default = 5
}
variable "location" {
  type    = string
  default = "eastus"
}
variable "availability_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}
variable "is_multi_az" {
  type    = bool
  default = true
}
variable "prefix" {
  type    = string
  default = "tf"
}
variable "data_storage_account_type" {
  type    = string
  default = "PremiumV2_LRS" #"Premium_LRS" #"UltraSSD_LRS"
}
variable "data_disk_size_gb" {
  type    = string
  default = "1024"
}
variable "data_disk_iops_read_write" {
  type    = string
  default = "4211"
}
variable "data_disk_mbps_read_write" {
  type    = string
  default = "125"
}
variable "data_disk_count" {
  type    = string
  default = 20
}
variable "resource_group_name" {
}
variable "tags" {
  description = "who owns those resources? identify yourself, this will be used as a tag"
  default = { user: null }
  
      validation {
    condition     = length(var.tags["user"]) > 0
    error_message = "The 'user' tag must be provided!"
  }  
}
variable "virtual_machine_prefix" {
  description = "vm name without index, e.g. for az-vm-0, az-vm-1...: az-vm"
}
variable "start_from_lun" {
  description = "start from lun 0 if vm has no disks, otherwise check which lun should be the starting one"
  default = 0
}
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
variable "pflex_enable_accelerated_networking" {
  type    = bool
  default = true
}
variable "pflex_enable_ip_forwarding" {
  type    = bool
  default = false
}
variable "pflex_shared_image" {
  type = map(string)
  default = {
    name                = "pflex"
    gallery_name        = "denver_gallery"
    resource_group_name = "eaus-powerflex-rg"
  }
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
variable "vm_size" {
  type = map(string)
  default = {
    pflex = "Standard_F48s_v2"
  }
}
variable "os_disk_size_gb" {
  type = map(string)
  default = {
    pflex = 512
    # jumphost = #take default
  }
}
variable "resource_group_name" {
}
variable "virtual_network_name" {
}
variable "default_subnet_name" {
  default = "default"
}
variable "load_balancer_name" {
}
variable "lb_be_address_pool_name" {
  default = "pfmp_pool"
}
variable "tags" {
  description = "who owns those resources? identify yourself, this will be used as a tag"
  default = { user: null }
  
      validation {
    condition     = length(var.tags["user"]) > 0
    error_message = "The 'user' tag must be provided!"
  }  
}
variable "use_ssh_keys" {
  description = "defines if ssh key should be used for authentication"
  default     = true
}

variable "public_key_path" {
  default = {
    installer : "../../ssh-keys/terraform-azure.pem.pub"
  cluster : "../../ssh-keys/terraform-azure.pem.pub" }
}

variable "cluster_node_count" {}
variable "location" {}
variable "resource_group_name" {}
variable "zones" {}
variable "os_disk_size_gb" {}
variable "source_image_id" {}
variable "vm_size" {}
variable "prefix" {}
variable "pflex_enable_accelerated_networking" {}
variable "pflex_enable_ip_forwarding" {}
variable "subnet_id" {}
variable "tags" {}
variable "use_ssh_keys" {}
variable "public_key_path" {}


resource "azurerm_network_interface" "pflex_managment_nic" {
  count                         = var.cluster_node_count
  name                          = "${var.prefix}-mgmt-nic-${count.index}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.pflex_enable_accelerated_networking
  enable_ip_forwarding          = var.pflex_enable_ip_forwarding

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "pflex_vm" {
  count                 = var.use_ssh_keys ? 0 : var.cluster_node_count
  name                  = "${var.prefix}-vm-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.pflex_managment_nic[count.index].id]
  size                  = var.vm_size
  zone                  = var.zones[count.index % length(var.zones)]

  # additional_capabilities {
  #   ultra_ssd_enabled = true
  # } #only set when using ultra disks

  os_disk {
    name                 = "${var.prefix}-os-disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.source_image_id

  admin_username                  = "pflexuser"
  admin_password                  = "PowerFlex123!"
  disable_password_authentication = false

  tags = {
    is_pfmp = count.index < 3 ? "true" : "false",
    user    = var.tags.user
  }
}

resource "azurerm_linux_virtual_machine" "pflex_vm_with_keys" {
  count                           = var.use_ssh_keys ? var.cluster_node_count : 0
  name                            = "${var.prefix}-vm-${count.index}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.pflex_managment_nic[count.index].id]
  size                            = var.vm_size
  zone                            = var.zones[count.index % length(var.zones)]
  disable_password_authentication = true


  os_disk {
    name                 = "${var.prefix}-os-disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.source_image_id

  admin_username = "pflexuser"
  admin_ssh_key {
    username   = "pflexuser"
    public_key = file("${var.public_key_path.cluster}")
  }

  tags = {
    is_pfmp = count.index < 3 ? "true" : "false",
    user    = var.tags.user
  }
}


output "cluster_node_ids" {
  value = var.use_ssh_keys ? azurerm_linux_virtual_machine.pflex_vm_with_keys[*].id : azurerm_linux_virtual_machine.pflex_vm[*].id
}
output "cluster_nics" {
  value = azurerm_network_interface.pflex_managment_nic
}

output "pfmp_os_disk_names" {
  value = var.use_ssh_keys ? [for vm in azurerm_linux_virtual_machine.pflex_vm_with_keys[*] : vm.tags.is_pfmp ? vm[*].os_disk[0].name : null] : [for vm in azurerm_linux_virtual_machine.pflex_vm[*] : vm.tags.is_pfmp ? vm[*].os_disk[0].name : null]
}
output "pfmp_private_ips" {
  value = var.use_ssh_keys ? [for vm in azurerm_linux_virtual_machine.pflex_vm_with_keys[*] : vm.tags.is_pfmp ? vm.private_ip_address : null] : [for vm in azurerm_linux_virtual_machine.pflex_vm[*] : vm.tags.is_pfmp ? vm.private_ip_address : null]
}

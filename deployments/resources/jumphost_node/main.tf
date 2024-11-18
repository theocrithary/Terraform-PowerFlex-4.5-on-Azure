variable "location" {}
variable "resource_group_name" {}
variable "zones" {}
variable "admin_username" {
  default = "pflexuser"
}
variable "admin_password" {
  default = "PowerFlex123!"
}
variable "disable_password_authentication" {
  default = false
}
variable "vm_size" {}
variable "subnet_id" {}
variable "prefix" {}
variable "source_image_reference" {}
variable "tags" {}


# Create network interface
resource "azurerm_network_interface" "jumphost_nic" {
  name                = "${var.prefix}-jumphost-nic"
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "pflex_vm" {
  name                  = "${var.prefix}-jumphost-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  zone                  = var.zones[0]
  network_interface_ids = [azurerm_network_interface.jumphost_nic.id]
  size                  = var.vm_size
  admin_username        = "pflexadmin"
  admin_password        = "PowerFlex123!"
  computer_name         = "win-jumphost"

  os_disk {
    name                 = "${var.prefix}-jumphost-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
  tags = {
    user = var.tags.user
  }
}

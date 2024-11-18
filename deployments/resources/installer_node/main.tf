variable "location" {}
variable "resource_group_name" {}
variable "zones" {}
variable "os_disk_size_gb" {}
variable "prefix" {}
variable "subnet_id" {}
# variable "source_image_reference" {}
variable "source_image_id" {}
variable "public_key_path" {}
variable "vm_size" {}
variable "tags" {}

resource "azurerm_network_interface" "installer_nic" {
  name                = "${var.prefix}-installer-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "installer_node" {
  name                  = "${var.prefix}-installer-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.installer_nic.id]
  size                  = var.vm_size
  zone                  = var.zones[0]

  os_disk {
    name                 = "${var.prefix}-installer-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  # source_image_reference {
  #   publisher = var.source_image_reference.publisher
  #   offer     = var.source_image_reference.offer
  #   sku       = var.source_image_reference.sku
  #   version   = var.source_image_reference.version
  # }
  source_image_id = var.source_image_id

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${var.public_key_path.installer}")
  }

  admin_username                  = "azureuser"
  disable_password_authentication = true

  tags = {
    user = var.tags.user
  }
}

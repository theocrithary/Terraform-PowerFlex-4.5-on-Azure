variable "location" {}
variable "name" {}
variable "tags" {}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags = { user: var.tags.user }
}


output "name" {
  value = azurerm_resource_group.rg.name
}
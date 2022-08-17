resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
#
# Define Resources Associated With The Virtual Network
#

#Create Resource Group
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

#Create Subnet
resource "azurerm_subnet" "ds" {
  name                 = "${var.name_prefix}-subnet-ds"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 8, 1)]
}

resource "azurerm_subnet" "psql" {
  name                 = "${var.name_prefix}-subnet-psql"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 8, 2)]
}

resource "azurerm_subnet" "k8s" {
  name                 = "${var.name_prefix}-subnet-k8s"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 8, 3)]
}

#Create NSG
resource "azurerm_network_security_group" "ds" {
  name                = "${var.name_prefix}-nsg-ds"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "nsg-ds-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "psql" {
  name                = "${var.name_prefix}-nsg-psql"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "nsg-psql-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "k8s" {
  name                = "${var.name_prefix}-nsg-k8s"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name

  security_rule {
    name                       = "nsg-k8s-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Create Subnet NSG Association
resource "azurerm_subnet_network_security_group_association" "ds" {
  subnet_id                 = azurerm_subnet.ds.id
  network_security_group_id = azurerm_network_security_group.ds.id
}

resource "azurerm_subnet_network_security_group_association" "psql" {
  subnet_id                 = azurerm_subnet.psql.id
  network_security_group_id = azurerm_network_security_group.psql.id
}

resource "azurerm_subnet_network_security_group_association" "k8s" {
  subnet_id                 = azurerm_subnet.k8s.id
  network_security_group_id = azurerm_network_security_group.k8s.id
}
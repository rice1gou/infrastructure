#
# Entory Point for Local Environment
#

# Difine Providers To Be Used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.27.0"
    }
  }
}

# Setting AzureRM Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Setting AzureAD Provider
provider "azuread" {}

# Define Local Variables
# Define Local Variables
locals {
  name_prefix = "dev"
}

# Create Resource Group
resource "azurerm_resource_group" "structure" {
  name     = var.structure_resource_group_name
  location = var.location
}

# Get Virtual Network Data
data "azurerm_virtual_network" "vnet" {
  name                = "${local.name_prefix}-vnet"
  resource_group_name = var.base_resource_group_name
}

# Get Subnet Data
data "azurerm_subnet" "ds" {
  name                 = "${local.name_prefix}-subnet-ds"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.base_resource_group_name
}

data "azurerm_subnet" "psql" {
  name                 = "${local.name_prefix}-subnet-psql"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.base_resource_group_name
}

data "azurerm_subnet" "k8s" {
  name                 = "${local.name_prefix}-subnet-k8s"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.base_resource_group_name
}

# Import Kubernetes Module
module "k8s" {
  source                   = "../../modules/k8s"
  base_resource_group_name = var.base_resource_group_name
  resource_group_name      = azurerm_resource_group.structure.name
  location                 = var.location
  name_prefix              = local.name_prefix
  node_count               = 3
  vm_size                  = "Standard_B2ms"
  subnet_id                = data.azurerm_subnet.k8s.id
  secret_rotation_interval = "60m"
}

# Import PostgreSQL Module
module "psql" {
  source                   = "../../modules/psql"
  base_resource_group_name = var.base_resource_group_name
  resource_group_name      = azurerm_resource_group.structure.name
  name_prefix              = local.name_prefix
  location                 = var.location
  subnet_id                = data.azurerm_subnet.psql.id
  vnet_id                  = data.azurerm_virtual_network.vnet.id
  sku_name                 = "B_Standard_B1ms"
  storage_mb               = 32768
  backup_retention_days    = 7
  administrator_login      = var.administrator_login
  administrator_password   = var.administrator_password

}

# Import Storage Account Module
module "sa" {
  source                   = "../../modules/sa"
  base_resource_group_name = var.base_resource_group_name
  resource_group_name      = azurerm_resource_group.structure.name
  name_prefix              = local.name_prefix
  location                 = var.location
  subnet_id                = data.azurerm_subnet.ds.id
  vnet_id                  = data.azurerm_virtual_network.vnet.id
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

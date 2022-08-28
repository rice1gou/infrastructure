#
# Entory Point for Develop Environment
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
  backend "azurerm" {}
}

# Setting AzureRM Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Setting AzureAD Provider
provider "azuread" {}

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

# Import Storage Account Module
module "sa" {
	source = "../../modules/sa"
	resource_group_name = azurerm_resource_group.structure.name
	location = var.location
	subnet_id = data.azurerm_subnet.ds.id
}

# Import PostgreSQL Module
module "psql" {
	source = "../../modules/psql"
	resource_group_name = azurerm_resource_group.structure.name
	location = var.location
	subnet_id = data.azurerm_subnet.psql.id
}

# Import Kubernetes Module
module "k8s" {
	source = "../../modules/k8s"
	resource_group_name = azurerm_resource_group.structure.name
	location = var.location
  name_prefix = local.name_prefix
  node_count = 3
  vm_size = "Standard_B2ms"
	subnet_id = data.azurerm_subnet.k8s.id
  secret_rotation_interval = "60m"
}

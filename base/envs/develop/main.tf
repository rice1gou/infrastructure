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
resource "azurerm_resource_group" "base" {
  name     = var.base_resource_group_name
  location = var.location
}

# Import Identity Module
module "id" {
  source              = "../../modules/id"
  resource_group_name = azurerm_resource_group.base.name
  resource_group_id   = azurerm_resource_group.base.id
  location            = var.location
  name_prefix         = local.name_prefix
}

# Import Key Vault Module
module "kv" {
  source                     = "../../modules/kv"
  resource_group_name        = azurerm_resource_group.base.name
  location                   = var.location
  name_prefix                = local.name_prefix
  soft_delete_retention_days = 7
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  infrastructure_group_name  = var.infrastructure_group_name
}

# Import Virtual Network Module
module "vnet" {
  source              = "../../modules/vnet"
  resource_group_name = azurerm_resource_group.base.name
  location            = var.location
  name_prefix         = local.name_prefix
  address_space       = var.address_space
}
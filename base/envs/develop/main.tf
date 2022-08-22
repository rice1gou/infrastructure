terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

locals {
  name_prefix = "dev"

}

#Create Resource Group
resource "azurerm_resource_group" "base" {
  name     = var.base_resource_group_name
  location = var.location
}

module "vnet" {
  source              = "../../modules/vnet"
  resource_group_name = azurerm_resource_group.base.name
  location            = var.location
  name_prefix         = local.name_prefix
  address_space       = var.address_space
}

module "kv" {
  source                     = "../../modules/kv"
  resource_group_name        = azurerm_resource_group.base.name
  location                   = var.location
  name_prefix                = local.name_prefix
  soft_delete_retention_days = 7
  sku_name                   = "standard"
}
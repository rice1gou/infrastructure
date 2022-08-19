terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

locals {
  name_prefix = "dev"
}

module "vnet" {
  source              = "../../modules/vnet"
  resource_group_name = var.network_resource_group_name
  location            = var.location
  name_prefix         = local.name_prefix
  address_space       = var.address_space
}
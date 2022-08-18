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
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
}

#
# 内部変数
#
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
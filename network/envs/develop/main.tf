terraform {
  required_providers {
    azurerm = {
    source  = "hashicorp/azurerm"
    version = "=3.18.0"
    }
  }

  backend "azurerm" {
  resource_group_name  = var.backend_resource_group_name
  storage_account_name = var.backend_storage_account_name
  container_name       = var.backend_container_name
  key                  = var.backend_key
  use_azuread_auth     = true
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
  name_prefix                 = "dev"

}

module "vnet" {
  source = "../../modules/vnet"
  resource_group_name = var.network_resource_group_name
  location = var.location
  name_prefix = local.name_prefix
  address_space = var.address_space
}
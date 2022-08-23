#
# Define Resources Associated With The Key Vault
#

# Get Current Tenant Information
data "azurerm_client_config" "current" {}

# Get AzureAD User Group
data "azuread_group" "infrastructure" {
  display_name     = var.infrastructure_group_name
  security_enabled = true
}

# Create Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = "${var.name_prefix}-base-kv"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.soft_delete_retention_days
  sku_name                   = var.sku_name
  enable_rbac_authorization  = var.enable_rbac_authorization
}

# Create Role Assignment to Management the Key Vault
resource "azurerm_role_assignment" "kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_group.infrastructure.id
}
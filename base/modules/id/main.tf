#
# Define Resources Associated With Identity
#

# Create Managed Identity
resource "azurerm_user_assigned_identity" "cp" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.name_prefix}-cp-id"
}

resource "azurerm_user_assigned_identity" "kubelet" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.name_prefix}-kubelet-id"
}

# Assign Role to Identity 
resource "azurerm_role_assignment" "cp" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cp.principal_id
}

resource "azurerm_role_assignment" "kubelet" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.kubelet.principal_id
}

resource "azurerm_role_assignment" "cp2kubelet" {
  scope                = azurerm_user_assigned_identity.kubelet.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.cp.principal_id
}
#
# Define Resources Associated With The Kubernetes
#

# Get Admin User Group Data
data "azuread_group" "k8s" {
  display_name     = var.infrastructure_group_name
  security_enabled = true
}

# Get Managed Identity Data
data "azurerm_user_assigned_identity" "kubelet" {
  name                = "${var.name_prefix}-kubelet-id"
  resource_group_name = var.base_resource_group_name
}

data "azurerm_user_assigned_identity" "cp" {
  name                = "${var.name_prefix}-cp-id"
  resource_group_name = var.base_resource_group_name
}

# Create Kubernetes
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.name_prefix}-k8s"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name_prefix}-k8s"

  # RBAC support
  local_account_disabled = true
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [data.azuread_group.k8s.id]
    azure_rbac_enabled     = true
  }

  # Private Cluster support
  # private_cluster_enabled = true
  # private_dns_zone_id     = azurerm_private_dns_zone.k8s.id

  # Define Node Pool
  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    enable_auto_scaling = false
    vnet_subnet_id      = var.subnet_id
  }

  # Define Authorization Identity Type
  identity {
    type         = "UserAssigned"
    identity_ids = data.azurerm_user_assigned_identity.cp.id
  }

  kubelet_identity {
    client_id                 = data.azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = data.azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = data.azurerm_user_assigned_identity.kubelet.id
  }

  # Define Secret Store CSI Driver
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = var.secret_rotation_interval
  }

  # Define Network Policy
  network_profile {
    network_plugin    = "kubenet"
    network_policy    = "calico"
    load_balancer_sku = "standard"

    # Define Loadbalancer
    load_balancer_profile {
      managed_outbound_ip_count = 1
      idle_timeout_in_minutes   = 30
    }
  }
}
#
# Privaet Cluster Support
#
# Create Kubernetes Private DNS Zone
#resource "azurerm_private_dns_zone" "k8s" {
#  name                = "privatelink.${var.location}.azmk8s.io"
#  resource_group_name = var.base_resource_group_name
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "k8s" {
#  name                  = "${var.name_prefix}-k8s-privatelink.com"
#  private_dns_zone_name = azurerm_private_dns_zone.k8s.name
#  virtual_network_id    = var.vnet_id
#  resource_group_name   = var.base_resource_group_name
#}

# Create Private endpoint
#resource "azurerm_private_endpoint" "k8s" {
#  name                = "${var.name_prefix}-k8s-ep"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  subnet_id           = var.subnet_id

#  private_service_connection {
#    name                           = "${var.name_prefix}-k8s-psc"
#    private_connection_resource_id = azurerm_kubernetes_cluster.k8s.id
#    subresource_names              = ["k8s"]
#    is_manual_connection           = false
#  }
#}

# Create A Record
#resource "azurerm_private_dns_a_record" "k8s" {
#  name                = azurerm_kubernetes_cluster.k8s.name
#  zone_name           = azurerm_private_dns_zone.k8s.name
#  resource_group_name = var.base_resource_group_name
#  ttl                 = 300
#  records             = [azurerm_private_endpoint.k8s.private_service_connection.0.private_ip_address]
#}

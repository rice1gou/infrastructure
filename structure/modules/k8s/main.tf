#
# Define Resources Associated With The Kubernetes
#

# Create Kubernetes
resource "azurerm_kubernetes_cluster" "k8s" {
  name                    = "${var.name_prefix}-k8s"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "${var.name_prefix}-k8s"
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
    type = "SystemAssigned"
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

# Create Kubernetes Private DNS Zone
#resource "azurerm_private_dns_zone" "k8s" {
#  name                = "privatelink.${var.location}.azmk8s.io"
#  resource_group_name = var.base_resource_group_name
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

#
# Define Resources Associated With The Storage Account
#

# Create Storage Account
resource "azurerm_storage_account" "blob" {
  name                      = "${var.name_prefix}rice1gouapp"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  is_hns_enabled            = true
  min_tls_version           = "TLS1_2"

  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.blob]
}

# Create Storage Account Private DNS Zone
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.base_resource_group_name
}

# Create Private endpoint
resource "azurerm_private_endpoint" "blob" {
  name                = "${var.name_prefix}-blob-ep"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.blob.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

# Private DNS Link to Vitual Network
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${var.name_prefix}-blob-privatelink.com"
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.base_resource_group_name
}

# Create A Record
resource "azurerm_private_dns_a_record" "blob" {
  name                = azurerm_storage_account.blob.name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = var.base_resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.blob.private_service_connection.0.private_ip_address]
}

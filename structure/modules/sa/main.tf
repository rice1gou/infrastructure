#
# Define Resources Associated With The Storage Account
#

# Create Storage Account
resource "azurerm_storage_account" "sa" {
  name = "${var.name_prefix}rice1gouapp"
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = true
  allow_blob_public_access = false
  is_hns_enabled = true

  blob_properties {

  }
}

# Create Storage Account Private DNS Zone
resource "azurerm_private_dns_zone" "sa" {
  name = "privatelink.blob.core.windows.net"
  resource_group_name = var.base_resource_group_name
}

# Create Private endpoint
resource "azurerm_private_endpoint" "sa" {
  name = "${var.name_prefix}-sa-ep"
  resource_group_name = var.resource_group_name
  location = var.location
  subnet_id = var.subnet_id

  private_service_connection {
    name = "${var.name_prefix}-sa-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
  }
}

# Create A Record
resource "azurerm_private_dns_a_record" "sa" {
  name = azurerm_storage_account.sa.name
  zone_name = azurerm_private_dns_zone.sa.name
  resource_group_name = var.base_resource_group_name
  ttl = 300
  records = [azurerm_private_endpoint.sa.private_service_connection.0.private_ip_address]
}

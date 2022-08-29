#
# Define Resources Associated With The PostgreSQL
#
resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = "${var.name_prefix}-psql-fs"
  resource_group_name    = var.resource_group_name
  location               = var.location
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.psql.id
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  backup_retention_days  = var.backup_retention_days
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  version                = "13"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.psql]
}

resource "azurerm_postgresql_flexible_server_database" "psql" {
  name      = "${var.name_prefix}-psql-fs-db"
  server_id = azurerm_postgresql_flexible_server.psql.id
  charset   = "UTF8"
  collation = "C"
}

# Create PostgreSQL Private DNS Zone
resource "azurerm_private_dns_zone" "psql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.base_resource_group_name
}

# Private DNS Link to Vitual Network
resource "azurerm_private_dns_zone_virtual_network_link" "psql" {
  name                  = "${var.name_prefix}-psql-privatelink.com"
  private_dns_zone_name = azurerm_private_dns_zone.psql.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.base_resource_group_name
}

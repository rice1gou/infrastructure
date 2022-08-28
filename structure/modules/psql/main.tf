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

# Create Private endpoint
resource "azurerm_private_endpoint" "psql" {
  name                = "${var.name_prefix}-psql-ep"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-psql-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.psql.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

# Create A Record
resource "azurerm_private_dns_a_record" "psql" {
  name                = azurerm_postgresql_flexible_server.psql.name
  zone_name           = azurerm_private_dns_zone.psql.name
  resource_group_name = var.base_resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.psql.private_service_connection.0.private_ip_address]
}

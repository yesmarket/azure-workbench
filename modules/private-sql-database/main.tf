resource "azurerm_mssql_server" "this" {
  name                          = "tailscale-demo-sql"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.database_username
  administrator_login_password  = var.database_password
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "this" {
  name      = "tailscale-demo-sqldb"
  server_id = azurerm_mssql_server.this.id
  collation = "SQL_Latin1_General_CP1_CI_AS"

  auto_pause_delay_in_minutes = 20
  max_size_gb                 = 8
  min_capacity                = 0.5
  storage_account_type        = "Local"
  zone_redundant              = false
}

resource "azurerm_private_endpoint" "this" {
  name                = "sql-pep"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "sql-pep-con"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-pep-pdz-grp"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.private_dns_zone_virtual_networks
  name                  = "${each.key}-vnet-sql-pdz-lnk"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value
}

resource "azurerm_storage_account" "this" {
  name                          = replace(local.storage_account_name, "-", "")
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false
}

#resource "azurerm_storage_container" "test" {
#  name                 = "test"
#  storage_account_name = azurerm_storage_account.this.name
#}

resource "azurerm_private_endpoint" "this" {
  name                = "${local.storage_account_name}-pep"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.storage_account_name}-pepcon"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${local.storage_account_name}-pepdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.private_dns_zone_virtual_networks
  name                  = "${local.storage_account_name}-${each.key}-vnet-pdz-lnk"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value
}

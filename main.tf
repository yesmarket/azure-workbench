# RGs
resource "azurerm_resource_group" "this" {
  name     = "tailscale-poc_rg"
  location = var.location
}

# VNETs
resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.hub_cidr
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.spoke_cidr
}

resource "azurerm_virtual_network_peering" "hub2spoke_peer" {
  name                         = "hub2spoke-peer"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke2hub_peer" {
  name                         = "spoke2hub-peer"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true

  depends_on = [azurerm_virtual_network_peering.hub2spoke_peer]
}

# subnets
resource "azurerm_subnet" "hub_public" {
  name                 = "hub-public-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.hub_cidr[0], 2, 0)]
}

resource "azurerm_subnet" "spoke_private" {
  name                 = "spoke-private-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_cidr[0], 2, 0)]
}

# misc internal VM
module "private_linux_vm" {
  source              = "./modules/private-linux-vm"
  name_prefix         = "misc"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  nic_subnet_id       = azurerm_subnet.spoke_private.id
  ssh_username        = var.ssh_username
  public_ssh_key      = var.public_ssh_key
}

# subnet-router
resource "azurerm_availability_set" "subnet_router_aset" {
  name                        = "subnet-router-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "subnet_router" {
  for_each            = toset(var.subnet_routers)
  source              = "./modules/subnet-router"
  name_prefix         = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  nic_subnet_id       = azurerm_subnet.hub_public.id
  ssh_username        = var.ssh_username
  auth_key            = var.subnet_router_auth_key
  advertised_routes   = "${var.hub_cidr[0]},${var.spoke_cidr[0]}"
  availability_set_id = azurerm_availability_set.subnet_router_aset.id
  public_ssh_key      = var.public_ssh_key
}

# app-connector
resource "azurerm_availability_set" "app_connector_aset" {
  name                        = "app-connector-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "app_connector" {
  for_each            = toset(var.app_connectors)
  source              = "./modules/app-connector"
  name_prefix         = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  nic_subnet_id       = azurerm_subnet.hub_public.id
  ssh_username        = var.ssh_username
  auth_key            = var.app_connector_auth_key
  advertised_tags     = var.app_connector_advertised_tags
  availability_set_id = azurerm_availability_set.app_connector_aset.id
  public_ssh_key      = var.public_ssh_key
}

# bastion host
#module "bastion" {
#  source = "./modules/bastion"
#  resource_group_name = azurerm_resource_group.this.name
#  location = azurerm_resource_group.this.location
#  virtual_network_name = azurerm_virtual_network.hub.name
#  subnet_cidr = cidrsubnet(var.hub_cidr[0], 2, 1)
#}

# private storage account
module "private_storage_account" {
  source                     = "./modules/private-storage-account"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  private_endpoint_subnet_id = azurerm_subnet.spoke_private.id
  private_dns_zone_virtual_networks = {
    hub   = azurerm_virtual_network.hub.id
    spoke = azurerm_virtual_network.spoke.id
  }
}

# private SQL database
module "private_sql_database" {
  source                     = "./modules/private-sql-database"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  database_username          = var.database_username
  database_password          = var.database_password
  private_endpoint_subnet_id = azurerm_subnet.spoke_private.id
  private_dns_zone_virtual_networks = {
    hub   = azurerm_virtual_network.hub.id
    spoke = azurerm_virtual_network.spoke.id
  }
}

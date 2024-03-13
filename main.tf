# RGs
resource "azurerm_resource_group" "this" {
  name     = "${local.naming_prefix}-rg"
  location = var.location
}

# VNETs
resource "azurerm_virtual_network" "network" {
  name                = "${local.naming_prefix}-network-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.network_vnet_cidr
}

resource "azurerm_virtual_network" "customer_managed" {
  name                = "${local.naming_prefix}-cm-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.cm_vnet_cidr
}

resource "azurerm_virtual_network_peering" "network2cm_peer" {
  name                         = "${local.naming_prefix}-network2cm-peer"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.network.name
  remote_virtual_network_id    = azurerm_virtual_network.customer_managed.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "cm2network_peer" {
  name                         = "${local.naming_prefix}-cm2network-peer"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.customer_managed.name
  remote_virtual_network_id    = azurerm_virtual_network.network.id
  allow_virtual_network_access = true

  depends_on = [azurerm_virtual_network_peering.network2cm_peer]
}

# subnets
resource "azurerm_subnet" "ingress" {
  name                 = "${local.naming_prefix}-network-ingress-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [cidrsubnet(var.network_vnet_cidr[0], 2, 0)]
}

resource "azurerm_subnet" "egress" {
  name                 = "${local.naming_prefix}-network-egress-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [cidrsubnet(var.network_vnet_cidr[0], 2, 1)]
}

module "natg" {
  source              = "./modules/nat-gateway"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.egress.id
}

resource "azurerm_subnet" "private" {
  name                 = "${local.naming_prefix}-cm-private-snet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.customer_managed.name
  address_prefixes     = [cidrsubnet(var.cm_vnet_cidr[0], 2, 0)]
}

# misc internal VM
module "private_linux_vm" {
  count               = var.add_private_linux_vm_cm_vnet ? 1 : 0
  source              = "./modules/private-linux-vm"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id
  ssh_username        = var.username
  ssh_public_key      = var.ssh_public_key
}

# subnet-router
resource "azurerm_availability_set" "tailscale_subnet_router_aset" {
  count                       = length(var.tailscale_subnet_routers) > 0 ? 1 : 0
  name                        = "${local.naming_prefix}-tailscale-subnet-router-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "tailscale_subnet_router" {
  for_each            = toset(var.tailscale_subnet_routers)
  source              = "./modules/tailscale-subnet-router"
  naming_prefix       = local.naming_prefix
  unique_identifier   = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.ingress.id
  ssh_username        = var.username
  ssh_public_key      = var.ssh_public_key
  auth_key            = var.tailscale_subnet_router_auth_key
  advertised_routes   = "${var.network_vnet_cidr[0]},${var.cm_vnet_cidr[0]}"
  availability_set_id = azurerm_availability_set.tailscale_subnet_router_aset.0.id
}

# app-connector
resource "azurerm_availability_set" "tailscale_app_connector_aset" {
  count                       = length(var.tailscale_app_connectors) > 0 ? 1 : 0
  name                        = "${local.naming_prefix}-tailscale-app-connector-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "tailscale_app_connector" {
  for_each            = toset(var.tailscale_app_connectors)
  source              = "./modules/tailscale-app-connector"
  naming_prefix       = local.naming_prefix
  unique_identifier   = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.ingress.id
  ssh_username        = var.username
  ssh_public_key      = var.ssh_public_key
  auth_key            = var.tailscale_app_connector_auth_key
  advertised_tags     = var.tailscale_app_connector_advertised_tags
  availability_set_id = azurerm_availability_set.tailscale_app_connector_aset.0.id
}

# bastion host
module "bastion" {
  count                = var.add_bastion ? 1 : 0
  source               = "./modules/bastion"
  naming_prefix        = local.naming_prefix
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  virtual_network_name = azurerm_virtual_network.network.name
  subnet_cidr          = cidrsubnet(var.network_vnet_cidr[0], 2, 1)
}

# private storage account
module "private_storage_account" {
  count                      = var.add_private_storage_account ? 1 : 0
  source                     = "./modules/private-storage-account"
  naming_prefix              = local.naming_prefix
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  private_endpoint_subnet_id = azurerm_subnet.private.id
  private_dns_zone_virtual_networks = {
    network          = azurerm_virtual_network.network.id
    customer_managed = azurerm_virtual_network.customer_managed.id
  }
}

# private SQL database
module "private_sql_database" {
  count                      = var.add_private_sql_server ? 1 : 0
  source                     = "./modules/private-sql-database"
  naming_prefix              = local.naming_prefix
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  database_username          = var.username
  database_password          = var.password
  private_endpoint_subnet_id = azurerm_subnet.private.id
  private_dns_zone_virtual_networks = {
    network          = azurerm_virtual_network.network.id
    customer_managed = azurerm_virtual_network.customer_managed.id
  }
}

# private vey vault
module "private_key_vault" {
  count                       = var.add_private_key_vault ? 1 : 0
  source                      = "./modules/private-key-vault"
  naming_prefix               = local.naming_prefix
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  tenant_id                   = var.tenant_id
  key_vault_full_access_users = var.key_vault_full_access_users
  key_vault_readers = {
    "ADF managed identity" = module.adf_workspace.0.data_factory_managed_identity
  }
  key_vault_secrets          = var.key_vault_secrets
  private_endpoint_subnet_id = azurerm_subnet.private.id
  private_dns_zone_virtual_networks = {
    network          = azurerm_virtual_network.network.id
    customer_managed = azurerm_virtual_network.customer_managed.id
  }
}

# GPG function app
module "gpg_function_app" {
  count               = var.add_gpg_function_app ? 1 : 0
  source              = "./modules/gpg-function-app"
  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = var.tenant_id
}

# ADF
module "adf_workspace" {
  count                       = var.add_adf_workspace || length(var.adf_shirs) > 0 ? 1 : 0
  source                      = "./modules/adf-workspace"
  naming_prefix               = local.naming_prefix
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  add_self_hosted_ir          = length(var.adf_shirs) > 0 ? true : false
  add_private_storage_account = var.add_private_storage_account
  add_private_sql_server      = var.add_private_sql_server
  add_private_key_vault       = var.add_private_key_vault
  private_storage_account_id  = var.add_private_storage_account ? module.private_storage_account.0.private_storage_account_id : null
  private_mssql_server_id     = var.add_private_sql_server ? module.private_sql_database.0.private_mssql_server_id : null
  private_key_vault_id        = var.add_private_key_vault ? module.private_key_vault.0.private_key_vault_id : null
}

# ADF SHIRs
resource "azurerm_availability_set" "adf_shir_aset" {
  count                       = length(var.adf_shirs) > 0 ? 1 : 0
  name                        = "${local.naming_prefix}-adf-shir-aset"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  platform_fault_domain_count = 2
}
module "adf_shir" {
  for_each            = toset(var.adf_shirs)
  source              = "./modules/adf-shir"
  naming_prefix       = local.naming_prefix
  unique_identifier   = each.key
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  auth_key            = module.adf_workspace.0.data_factory_shir_auth_key
  subnet_id           = azurerm_subnet.egress.id
  rdp_username        = var.username
  rdp_password        = var.password
  availability_set_id = azurerm_availability_set.adf_shir_aset.0.id
}

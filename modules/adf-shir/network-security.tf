#resource "azurerm_network_security_group" "this" {
#  name                = "adf-shir-${var.name_suffix}-nsg"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#}
#
#resource "azurerm_network_security_rule" "rdp_3389_inbound_nsgsr" {
#  name                        = "rdp-3389-inbound-nsgsr-${var.name_suffix}"
#  priority                    = 300
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "3389"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = var.resource_group_name
#  network_security_group_name = azurerm_network_security_group.this.name
#}
#
#resource "azurerm_network_security_rule" "icmp_inbound_nsgsr" {
#  name                        = "allow-ping-inbound-nsgsr"
#  priority                    = 301
#  direction                   = "Inbound"
#  access                      = "Allow"
#  protocol                    = "Icmp"
#  source_port_range           = "*"
#  destination_port_range      = "*"
#  source_address_prefix       = "VirtualNetwork"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_network_security_rule" "ssh_22_outbound_nsgsr" {
#  name                        = "ssh-22-outbound-nsgsr"
#  priority                    = 302
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "Tcp"
#  source_port_range           = "*"
#  destination_port_range      = "22"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.this.name
#  network_security_group_name = azurerm_network_security_group.tailscale_nsg.name
#}
#
#resource "azurerm_subnet_network_security_group_association" "this" {
#  subnet_id                 = var.subnet_id
#  network_security_group_id = azurerm_network_security_group.this.id
#}

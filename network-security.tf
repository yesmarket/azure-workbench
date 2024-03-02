#resource "azurerm_network_security_group" "tailscale_nsg" {
#  name                = "tailscale-nsg"
#  resource_group_name = azurerm_resource_group.this.name
#  location            = azurerm_resource_group.this.location
#}
#
#resource "azurerm_network_security_rule" "ssh_nsgsr" {
#  name                        = "ssh-nsgsr"
#  priority                    = 100
#  direction                   = "Inbound"
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
#resource "azurerm_subnet_network_security_group_association" "tailscale_snet_nsga" {
#  subnet_id                 = azurerm_subnet.hub_public.id
#  network_security_group_id = azurerm_network_security_group.tailscale_nsg.id
#}

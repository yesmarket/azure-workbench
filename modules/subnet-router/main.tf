resource "azurerm_public_ip" "this" {
  name                = "${var.name_prefix}-tailscale-subnet-router-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name_prefix}-tailscale-subnet-router-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name_prefix}-tailscale-subnet-router-cfg"
    subnet_id                     = var.nic_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "${var.name_prefix}-tailscale-subnet-router-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.ssh_username
  availability_set_id = var.availability_set_id

  custom_data = base64encode(templatefile("${path.module}/templates/bootstrap-script.tpl", {
    auth_key          = var.auth_key
    advertised_routes = var.advertised_routes
  }))

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.ssh_username
    public_key = var.public_ssh_key
  }

  os_disk {
    name                 = "${var.name_prefix}-tailscale-subnet-router-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

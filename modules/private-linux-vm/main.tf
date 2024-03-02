resource "azurerm_network_interface" "this" {
  name                = "${var.name_prefix}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name_prefix}-cfg"
    subnet_id                     = var.nic_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "${var.name_prefix}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.ssh_username

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.ssh_username
    public_key = var.public_ssh_key
  }

  os_disk {
    name                 = "${var.name_prefix}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
}

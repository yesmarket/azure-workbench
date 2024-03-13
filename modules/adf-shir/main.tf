resource "azurerm_network_interface" "this" {
  name                = "${local.adf_shir_vm_name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${local.adf_shir_vm_name}-cfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = replace(local.adf_shir_vm_compact_name, "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.rdp_username
  admin_password      = var.rdp_password
  availability_set_id = var.availability_set_id
  secure_boot_enabled = false

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    name                 = "${local.adf_shir_vm_name}-osdisk"
    caching              = var.disk_caching
    storage_account_type = var.disk_storage_account_type
  }

  source_image_id = var.source_image_id
}

resource "azurerm_virtual_machine_extension" "this" {
  name                 = "${local.adf_shir_vm_name}-vmext"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9.5"

  protected_settings = <<SETTINGS
{    
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -command C:/temp/RegisterGateway.ps1 -authKey ${var.auth_key}"
}
SETTINGS
}

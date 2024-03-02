variable "name_prefix" {
  type        = string
  description = "(Required) The name prefix for the VM (and related resources)."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the VM (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the VM."
}

variable "nic_subnet_id" {
  type        = string
  description = "(Required) The location of the VM."
}

variable "ssh_username" {
  type        = string
  description = "(Required) The SSH username for accessing the VM."
}

variable "public_ssh_key" {
  type        = string
  description = "(Required) The SSH public key for accessing the VM."
}

variable "vm_size" {
  type        = string
  description = "(Optional) The size of the VM."
  default     = "Standard_F2"
}

variable "disk_caching" {
  type        = string
  description = "(Optional) The VM disk caching."
  default     = "ReadWrite"
}

variable "disk_storage_account_type" {
  type        = string
  description = "(Optional) The VM disk storage account type."
  default     = "Standard_LRS"
}

variable "source_image_publisher" {
  type        = string
  description = "(Optional) The source image publisher"
  default     = "Canonical"
}

variable "source_image_offer" {
  type        = string
  description = "(Optional) The source image offer"
  default     = "0001-com-ubuntu-server-jammy"
}

variable "source_image_sku" {
  type        = string
  description = "(Optional) The source image sku"
  default     = "22_04-lts"
}

variable "source_image_version" {
  type        = string
  description = "(Optional) The source image version"
  default     = "latest"
}

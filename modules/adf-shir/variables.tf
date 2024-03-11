variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."  
}

variable "unique_identifier" {
  type        = string
  description = "The identifier for this specific ADF SHIR in a HA deployment."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the ADF SHIR (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the ADF SHIR."
}

variable "auth_key" {
  type        = string
  description = "The auth key for the data factory self-hosted IR."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to deploy the ADF SHIR."
}

variable "rdp_username" {
  type        = string
  description = "The RDP username for accessing the ADF SHIR."
}

variable "rdp_password" {
  type        = string
  description = "The RDP password for accessing the ADF SHIR."
}

variable "availability_set_id" {
  type        = string
  description = "The availability set to use for the ADF SHIR."
}

variable "ir_msi_url" {
  type        = string
  description = "The download URL of the self-hosted integration runtime."
  default     = "https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_5.36.8726.3.msi"
}

variable "vm_size" {
  type        = string
  description = "The size of the VM."
  default     = "Standard_A4_v2"
}

variable "disk_caching" {
  type        = string
  description = "The VM disk caching."
  default     = "ReadWrite"
}

variable "disk_storage_account_type" {
  type        = string
  description = "The VM disk storage account type."
  default     = "Standard_LRS"
}

variable "source_image_publisher" {
  type        = string
  description = "The source image publisher"
  default     = "MicrosoftWindowsServer"
}

variable "source_image_offer" {
  type        = string
  description = "The source image offer"
  default     = "WindowsServer"
}

variable "source_image_sku" {
  type        = string
  description = "The source image sku"
  default     = "2022-Datacenter"
}

variable "source_image_version" {
  type        = string
  description = "The source image version"
  default     = "latest"
}

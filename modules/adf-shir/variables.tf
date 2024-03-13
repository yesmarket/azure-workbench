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

variable "vm_size" {
  type        = string
  description = "The size of the VM."
  default     = "Standard_D4ls_v5"
}

variable "disk_caching" {
  type        = string
  description = "The VM disk caching."
  default     = "ReadWrite"
}

variable "disk_storage_account_type" {
  type        = string
  description = "The VM disk storage account type."
  default     = "Premium_LRS"
}

variable "source_image_id" {
  type        = string
  description = "The ADF SHIR custom image id"
  default     = "/subscriptions/46934691-fbae-44fe-abb8-900c33ca8095/resourceGroups/managed-images/providers/Microsoft.Compute/images/adf-shir-windows-server-2019"
}

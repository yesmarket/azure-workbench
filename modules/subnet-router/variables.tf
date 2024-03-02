variable "name_prefix" {
  type        = string
  description = "(Required) The name prefix for the subnet-router (and related resources)."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the subnet-router (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the subnet-router."
}

variable "nic_subnet_id" {
  type        = string
  description = "(Required) The location of the subnet-router."
}

variable "ssh_username" {
  type        = string
  description = "(Required) The SSH username for accessing the subnet-router."
}

variable "public_ssh_key" {
  type        = string
  description = "(Required) The SSH public key for accessing the subnet-router."
}

variable "auth_key" {
  type        = string
  description = "(Required) The auth key to authenticate the subnet-router without an interactive login."
  sensitive   = true
}

variable "advertised_routes" {
  type        = string
  description = "(Required) The IP ranges/addresses that will go to the subnet-router."
}

variable "vm_size" {
  type        = string
  description = "(Optional) The size of the subnet-router VM."
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

variable "availability_set_id" {
  type        = string
  description = "(Required) The availability set to use for the subnet-router."
}

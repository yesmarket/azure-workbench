variable "name_prefix" {
  type        = string
  description = "(Required) The name prefix for the app-connector (and related resources)."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the app-connector (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the app-connector."
}

variable "nic_subnet_id" {
  type        = string
  description = "(Required) The location of the app-connector."
}

variable "ssh_username" {
  type        = string
  description = "(Required) The SSH username for accessing the app-connector."
}

variable "public_ssh_key" {
  type        = string
  description = "(Required) The SSH public key for accessing the app-connector."
}

variable "auth_key" {
  type        = string
  description = "(Required) The auth key to authenticate the app-connector without an interactive login."
  sensitive   = true
}

variable "advertised_tags" {
  type        = string
  description = "(Required) The tag for the app-connector - tags are used to select which app connector to use for an app in Tailscale."
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

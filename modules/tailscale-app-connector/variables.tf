variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."  
}

variable "unique_identifier" {
  type        = string
  description = "The identifier for this specific app-connector in a HA deployment."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the app-connector (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the app-connector."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to deploy the app-connector."
}

variable "ssh_username" {
  type        = string
  description = "The SSH username for accessing the app-connector."
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing the app-connector."
}

variable "auth_key" {
  type        = string
  description = "The auth key to authenticate the app-connector without an interactive login."
  sensitive   = true
}

variable "advertised_tags" {
  type        = string
  description = "The tag for the app-connector - tags are used to select which app connector to use for an app in Tailscale."
}

variable "vm_size" {
  type        = string
  description = "The size of the app-connector VM."
  default     = "Standard_F2"
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

variable "source_image_id" {
  type        = string
  description = "The tailscale subnet-router custom image id"
  default     = "/subscriptions/46934691-fbae-44fe-abb8-900c33ca8095/resourceGroups/managed-images/providers/Microsoft.Compute/images/tailscale-app-connector"
}

variable "availability_set_id" {
  type        = string
  description = "The availability set to use for the subnet-router."
}

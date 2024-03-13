variable "tenant_id" {
  type        = string
  description = "AAD tennant ID."
}

variable "client_id" {
  type        = string
  description = "Azure service principal client ID."
}

variable "client_secret" {
  type        = string
  description = "Azure service principal client secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "location" {
  type        = string
  description = "Azure subscription ID."
  default     = "Australia East"
}

variable "username" {
  type        = string
  description = "The SSH username for accessing VMs."
  default     = "ryanbartsch"
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH public key for accessing VMs."
}

variable "password" {
  type        = string
  description = "The password for SQL auth to the Azure SQL Database."
  sensitive   = true
}

variable "tailscale_subnet_router_auth_key" {
  type        = string
  description = "Used to authenticate subnet-router VMs without an interactive login."
  sensitive   = true
}

variable "tailscale_app_connector_auth_key" {
  type        = string
  description = "Used to authenticate app-connector VMs without an interactive login."
  sensitive   = true
}

variable "tailscale_app_connector_advertised_tags" {
  type        = string
  description = "This is the tag for the app-connector - tags are used to select which app connectors for an app."
  default     = "tag:connector"
}

variable "tailscale_subnet_routers" {
  type        = list(any)
  description = "A list of subnet-routers to deploy. Multiple items represents a HA subnet-router configuraiton."
  default     = ["primary"]
}

variable "tailscale_app_connectors" {
  type        = list(any)
  description = "A list of app-connectors to deploy. Multiple items represents a HA app-connector configuraiton."
  default     = ["primary"]
}

variable "adf_shirs" {
  type        = list(any)
  description = "A list of ADF SHIRs to deploy. Multiple items represents a HA SHIR configuraiton."
  default     = ["1"]
}

variable "network_vnet_cidr" {
  type        = list(any)
  description = "CIDR range for the network VNET."
  default     = ["10.0.0.0/24"]
}

variable "cm_vnet_cidr" {
  type        = list(any)
  description = "CIDR range for the main VNET."
  default     = ["10.0.1.0/24"]
}

variable "key_vault_full_access_users" {
  type        = map(string)
  description = "AAD security principals (object IDs) with full access to key vault secrets"
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "Azure Key Vault secrets."
}

variable "add_bastion" {
  type        = bool
  description = "Determines whether to create a bastion or not."
  default     = false
}

variable "add_private_storage_account" {
  type        = bool
  description = "Determines whether to create a private storage account or not."
  default     = true
}

variable "add_private_sql_server" {
  type        = bool
  description = "Determines whether to create a private SQL database or not."
  default     = true
}

variable "add_private_key_vault" {
  type        = bool
  description = "Determines whether to create a private key vault or not."
  default     = true
}

variable "add_gpg_function_app" {
  type        = bool
  description = "Determines whether to create a GPG function app or not."
  default     = true
}

variable "add_private_linux_vm_cm_vnet" {
  type        = bool
  description = "Determines whether to create a private linux VM in the customer managed VNET or not."
  default     = false
}

variable "add_adf_workspace" {
  type        = bool
  description = "determines whether to create an ADF workspace or not."
  default     = true
}

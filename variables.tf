variable "tenant_id" {
  type        = string
  description = "(Required) AAD tennant ID."
}

variable "client_id" {
  type        = string
  description = "(Required) Azure service principal client ID."
}

variable "client_secret" {
  type        = string
  description = "(Required) Azure service principal client secret."
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "(Required) Azure subscription ID."
}

variable "location" {
  type        = string
  description = "(Required) Azure subscription ID."
  default     = "Australia East"
}

variable "ssh_username" {
  type        = string
  description = "(Required) The SSH username for accessing VMs."
  default     = "ryanbartsch"
}

variable "public_ssh_key" {
  type        = string
  description = "(Required) The SSH public key for accessing VMs."
}

variable "database_username" {
  type        = string
  description = "(Required) The username for SQL auth to the Azure SQL Database."
  default     = "ryanbartsch"
}

variable "database_password" {
  type        = string
  description = "(Required) The password for SQL auth to the Azure SQL Database."
  sensitive   = true
}

variable "subnet_router_auth_key" {
  type        = string
  description = "(Required) Used to authenticate subnet-router VMs without an interactive login."
  sensitive   = true
}

variable "app_connector_auth_key" {
  type        = string
  description = "(Required) Used to authenticate app-connector VMs without an interactive login."
  sensitive   = true
}

variable "app_connector_advertised_tags" {
  type        = string
  description = "(Optional) This is the tag for the app-connector - tags are used to select which app connectors for an app."
  default     = "tag:connector"
}

variable "subnet_routers" {
  type        = list(any)
  description = "(Optional) A list of subnet-routers to deploy. Multiple items represents a HA subnet-router configuraiton."
  default     = ["primary"]
}

variable "app_connectors" {
  type        = list(any)
  description = "(Optional) A list of app-connectors to deploy. Multiple items represents a HA app-connector configuraiton."
  default     = ["primary"]
}

variable "hub_cidr" {
  type        = list(any)
  description = "(Optional) CIDR range for the hub VNET."
  default     = ["10.0.0.0/24"]
}

variable "spoke_cidr" {
  type        = list(any)
  description = "(Optional) CIDR range for the spoke VNET."
  default     = ["10.0.1.0/24"]
}

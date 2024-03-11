variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."	
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the ADF workspace (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the ADF workspace."
}

variable "add_self_hosted_ir" {
  type        = bool
  description = "determines whether to create a self-hosted IR or not."
}

variable "add_private_storage_account" {
  type        = bool
  description = "Determines whether to create a private storage account or not."
  default     = true
}

variable "add_private_sql_database" {
  type        = bool
  description = "Determines whether to create a private SQL database or not."
  default     = true
}

variable "add_private_key_vault" {
  type        = bool
  description = "Determines whether to create a private key vault or not."
  default     = true
}

variable "private_storage_account_id" {
  type        = string
  description = "Determines whether to create a private storage account or not."
  default 	  = null
}

variable "private_mssql_database_id" {
  type        = string
  description = "Determines whether to create a private SQL database or not."
  default 	  = null
}

variable "private_key_vault_id" {
  type        = string
  description = "Determines whether to create a private key vault or not."
  default 	  = null
}

variable "managed_ir_vm_size" {
  type        = string
  description = "The size of the nodes on which the Managed Integration Runtime runs."
  default 	  = "Standard_A4_v2"
}

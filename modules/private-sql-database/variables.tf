variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the SQL database (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the SQL database."
}

variable "database_username" {
  type        = string
  description = "The SQL auth username for the Azure SQL Database."
}

variable "database_password" {
  type        = string
  description = "The SQL auth password for the Azure SQL Database."
  sensitive   = true
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "(Required) The subnet where the SQL database private endpoint will be deployed."
}

variable "private_dns_zone_virtual_networks" {
  type        = map(any)
  description = "(Required) The virtual networks that will be linked to the private DNS zone that contains DNS records to resolve the SQL database private endpoint IP address. Note: this is a map, because we might want this DNS config in multiple peered networks."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the storage account (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the storage account."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "(Required) The subnet where the storage account private endpoint will be deployed."
}

variable "private_dns_zone_virtual_networks" {
  type        = map(any)
  description = "(Required) The virtual networks that will be linked to the private DNS zone that contains DNS records to resolve the storage account private endpoint IP address. Note: this is a map, because we might want this DNS config in multiple peered networks."
}
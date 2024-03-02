variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group that will contain the bastion (and related resources)."
}

variable "location" {
  type        = string
  description = "(Required) The location of the bastion."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The virtual network that will contain the bastion."
}

variable "subnet_cidr" {
  type        = string
  description = "(Required) The CIDR range of the bastion subnet."
}

variable "scale_units" {
  type        = number
  description = "(Optional) the number of scale units for the bastion host."
  default     = 2
}

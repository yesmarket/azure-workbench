variable "naming_prefix" {
  type        = string
  description = "The naming prefix for all resource in this module."  
}

variable "resource_group_name" {
  type        = string
  description = "The resource group that will contain the bastion (and related resources)."
}

variable "location" {
  type        = string
  description = "The location of the bastion."
}

variable "virtual_network_name" {
  type        = string
  description = "The virtual network that will contain the bastion."
}

variable "subnet_cidr" {
  type        = string
  description = "The CIDR range of the bastion subnet."
}

variable "scale_units" {
  type        = number
  description = "the number of scale units for the bastion host."
  default     = 2
}

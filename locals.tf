resource "random_string" "this" {
  length  = 7
  special = false
  upper   = false
}

locals {
  naming_prefix = "lab-${random_string.this.result}"
}

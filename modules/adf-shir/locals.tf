data "template_file" "this" {
  template = file("${path.module}/templates/InstallGatewayOnLocalMachine.ps1")
  vars = {
    ir_msi_url = var.ir_msi_url
    auth_key   = var.auth_key
  }
}

locals {
  
  commandToExecute = jsonencode({
    commandToExecute = "powershell -encodedCommand ${textencodebase64(data.template_file.this.rendered, "UTF-16LE")}"
  })

  asf_shir_vm_name = "${var.naming_prefix}-adf-shir-${var.unique_identifier}-vm"
}

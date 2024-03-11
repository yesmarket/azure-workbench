output "tailscale_subnet_router_public_ip" {
  value = values(module.tailscale_subnet_router).*.public_ip
}

output "tailscale_subnet_router_private_ip" {
  value = values(module.tailscale_subnet_router).*.private_ip
}

#output "tailscale_app_connector_public_ip" {
#  value = values(module.tailscale_app_connector).*.public_ip
#}
#
#output "tailscale_app_connector_private_ip" {
#  value = values(module.tailscale_app_connector).*.private_ip
#}
#
#output "misc_internal_private_ip" {
#  value = module.private_linux_vm.private_ip
#}

output "ansible_hosts" {
  value = {
    for name, ip in azurerm_public_ip.ips : lower(name) => ip.ip_address
  }
}

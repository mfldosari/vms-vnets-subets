output "ansible_hosts" {
  value = {
    for emp in local.employees_active :
    emp.formatted_name => {
      full_name = emp.name
      ip        = azurerm_public_ip.ips[emp.formatted_name].ip_address
      email     = emp.email
      pass      = emp.default_password
    }
  }
}

output "employee_nic_ids" {
  description = "The list of employee NIC IDs"
  value = [for nic in azurerm_network_interface.employee_nic : nic.id]
}

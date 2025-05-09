output "employee_vm_info" {
  value = {
    for name, emp in azurerm_windows_virtual_machine.employee_vm :
    name => {
      ip      = azurerm_network_interface.employee_nic[name].ip_configuration[0].private_ip_address
      name    = name
    }
  }
}

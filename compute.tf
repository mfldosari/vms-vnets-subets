resource "azurerm_windows_virtual_machine" "employee_vm" {
  for_each = { for emp in local.employees_active : emp.formatted_name => emp }
  name                = "${each.key}-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = each.key
  admin_password      = each.value.default_password
  network_interface_ids = [
    azurerm_network_interface.employee_nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.key}-osdisk"
  }

source_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-standard"        
  version   = "latest"
}
}
resource "azurerm_linux_virtual_machine" "employee_vm" {
  for_each            = { for emp in local.employees_active : emp.formatted_name => emp }
  name                = "${each.key}-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = each.value.default_password

  admin_ssh_key {
    username = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  
  }
  network_interface_ids = [
    azurerm_network_interface.employee_nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.key}-osdisk"
  }

source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}
}
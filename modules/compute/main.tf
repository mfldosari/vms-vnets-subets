resource "azurerm_linux_virtual_machine" "employee_vm" {
  for_each            = { for emp in local.employees_active : emp.formatted_name => emp }
  name                = "${each.key}-vm"
  location            = var.rg_location
  resource_group_name = var.rg_name
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = each.value.default_password

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  network_interface_ids = var.network_interface_ids

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
resource "null_resource" "run" {
  depends_on = [azurerm_linux_virtual_machine.employee_vm]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "bash ${path.root}/Scripts/hosts_file_creator.sh"
  }
}

resource "null_resource" "send_email" {
  depends_on = [azurerm_linux_virtual_machine.employee_vm]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "bash ${path.root}/Scripts/Send_emails.sh"
  }
}
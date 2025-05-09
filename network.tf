resource "azurerm_virtual_network" "vnet_main" {
  depends_on          = [azurerm_resource_group.main]
  name                = "companyA-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnets" {
  depends_on = [azurerm_virtual_network.main]

  for_each = toset(local.departments)

  name                 = "${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet_main.name

  # Assign a unique address prefix for each department based on index
  address_prefixes = ["10.0.${index(local.departments_list, each.key)}.0/24"]
}


resource "azurerm_network_interface" "employee_nic" {
  depends_on = [azurerm_subnet.subnets]
  for_each   = { for emp in local.employees_active : emp.formatted_name => emp }

  name                = "${each.key}-nic" # Use employee's name as part of the NIC name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.department].id # Assign to correct subnet based on department
    private_ip_address_allocation = "Dynamic"
  }
}




resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each                  = azurerm_network_interface.employee_nic
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_virtual_network" "vnet_main" {
  name                = "companyA-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

# Creates a static public IP address for use with a network interface
resource "azurerm_public_ip" "ips" {
  for_each            = { for emp in local.employees_active : emp.formatted_name => emp }
  name                = "${each.key}-ip" # Use employee's name as part of the NIC name
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"

}

resource "azurerm_subnet" "subnets" {

  for_each = toset(local.departments)

  name                 = "${each.key}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_main.name

  # Assign a unique address prefix for each department based on index
  address_prefixes = ["10.0.${index(local.departments_list, each.key)}.0/24"]
}


resource "azurerm_network_interface" "employee_nic" {
  depends_on = [azurerm_subnet.subnets]
  for_each   = { for emp in local.employees_active : emp.formatted_name => emp }

  name                = "${each.key}-nic" # Use employee's name as part of the NIC name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.department].id # Assign to correct subnet based on department
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ips[each.value.formatted_name].id
  }
}




resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowRDT"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each                  = azurerm_network_interface.employee_nic
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
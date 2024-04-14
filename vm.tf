#VM vnet and subnet
resource "azurerm_virtual_network" "azarch-vm-vnet" {
    name = var.azarch-vm-vnet_name
    resource_group_name = azurerm_resource_group.azarch-rg.name
    location = azurerm_resource_group.azarch-rg.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "azarch-vm-subnet" {
  name                 = var.azarch-vm-subnet_name
  resource_group_name  = azurerm_resource_group.azarch-rg.name
  virtual_network_name = azurerm_virtual_network.azarch-vm-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#VM NSG
resource "azurerm_network_security_group" "azarch-vm-nsg" {
  name                = var.azarch-vm-nsg_name
  location            = azurerm_resource_group.azarch-rg.location
  resource_group_name = azurerm_resource_group.azarch-rg.name
}
resource "azurerm_network_security_rule" "azarch-vm-nsg-rules" {
  name                        = "AllowRDP"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.azarch-rg.name
  network_security_group_name = azurerm_network_security_group.azarch-vm-nsg.name
}
#VM NIC
resource "azurerm_network_interface" "azarch-vm-nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.azarch-rg.location
  resource_group_name = azurerm_resource_group.azarch-rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azarch-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
#VM
resource "azurerm_windows_virtual_machine" "azarch-vm" {
  name                = var.azarch-vm_name
  resource_group_name = azurerm_resource_group.azarch-rg.name
  location            = azurerm_resource_group.azarch-rg.location
  size                = "Standard B2s"
  admin_username      = var.azarch-vm_username
  admin_password      = var.azarch-vm_passwd
  network_interface_ids = [
    azurerm_network_interface.azarch-vm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

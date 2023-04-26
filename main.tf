provider "azurerm" {
  features {}

  client_id = "d1039414-9314-42c1-83d6-f336506448be"      
  client_secret = "YEr8Q~J6xTAMdYVSc52i.pIZqSAe7hGaXkJ~Fc~V"
  tenant_id = "e4a9f199-eafb-4fe7-99b5-a3c79a614634"
  subscription_id = "f372e468-bc73-46a8-bb79-9f0517b9d11a"
}

resource "azurerm_resource_group" "RG" {
  name     = "ASHA"
  location = "East us"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "Ashs-vnet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = "Asha-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "publicip" {
  name                = "Asha-publicip"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "Asha-nic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "example" {
  name                = "Asha-machine"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "adminuser@123"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
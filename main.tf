provider "azurerm" {
  features {}

  client_id = "d1039414-9314-42c1-83d6-f336506448be"      
  client_secret = "YEr8Q~J6xTAMdYVSc52i.pIZqSAe7hGaXkJ~Fc~V"
  tenant_id = "e4a9f199-eafb-4fe7-99b5-a3c79a614634"
  subscription_id = "f372e468-bc73-46a8-bb79-9f0517b9d11a"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg1"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "Balaji-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "example" {
  name                 = "Balaji-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10yea.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "example" {
  name                = "balajistorage"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.example.id]
  }
}
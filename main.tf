provider "azurerm" {
  features {}

  client_id = "e5a5cd38-7a78-4b44-b4e5-c5f20d97dcab "      
  client_secret = " 2Px8Q~lLI3-djsSc8O~xRoXJWHDi2wcsbnn8kaFZ"

  tenant_id = "e4a9f199-eafb-4fe7-99b5-a3c79a614634"
  subscription_id = "f372e468-bc73-46a8-bb79-9f0517b9d11a"
}
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "balajiwebapp9177"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}

provider "azurerm1" {
  features {}
}

resource "azurerm_resource_group" "example_ruth" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_service_plan" "example_ruth" {
  name                = "example.ruth"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "example_ruth" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

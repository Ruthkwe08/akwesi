locals{
  webapp=[for f in fileset("${path.module}/lbfolder", "[^_]*.yaml") : yamldecode(file("${path.module}/lbfolder/${f}"))]
  azurewebapp_content = flatten([
    for app in local.webapp: [
      for one in try(app.webapp, []) :{
        name=hello.webappname
      }
    ]
])


resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
linux_fx_version = "DOCKER|hello-world"
  }
}

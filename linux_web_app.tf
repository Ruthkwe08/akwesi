```hcl provider "azurerm" { features {} } 
resource "azurerm_resource_group" "example" 
{ 
name = "example-resources" 
location = "East US" 
} 
resource "azurerm_app_service_plan" "example" 
{ 
name = "example-app-service-plan" 
location = azurerm_resource_group.example.location 
resource_group_name = azurerm_resource_group.example.name 
kind = "Linux" sku { tier = "Standard" size = "S1" } 
} 
resource "azurerm_web_app" "example" { 
name = "example-web-app" 
location = azurerm_resource_group.example.location 
resource_group_name = azurerm_resource_group.example.name app_service_plan_id = azurerm_app_service_plan.example.id site_config 
{ 
linux_fx_version = "DOCKER|hello-world" 
} 
}

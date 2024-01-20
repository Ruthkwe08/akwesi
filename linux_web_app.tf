# Define variables
variable "resource_group_name" {
  type    = string
  default = "your-resource-group"
}

variable "app_service_plan_name" {
  type    = string
  default = "your-app-service-plan"
}

variable "web_app_name" {
  type    = string
  default = "your-web-app"
}

# Azure provider block
provider "azurerm" {
  features = {}
  # Add authentication details or use other methods like Managed Identity
}

# Resource block for creating an Azure App Service Plan
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = "East US" # Change as needed
  kind                = "Linux"

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Resource block for creating an Azure Web App
resource "azurerm_app_service" "web_app" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = azurerm_app_service_plan.app_service_plan.location
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|your-docker-image-url:tag" # Replace with your Docker image details
  }

  # Additional configurations such as app settings, connection strings, etc., can be added as needed.
}



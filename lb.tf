locals{
  lb=[for f in fileset("${path.module}/lbfolder", "[^_]*.yaml") : yamldecode(file("${path.module}/waffolder/${f}"))]
  azurelb_list = flatten([
    for app in local.lb: [
      for azurelb in try(app.listoflb, []) :{
        name=azurelb.name
      }
    ]
])
}
resource "azurerm_resource_group" "example1" {
  name     = "LoadBalancerRG"
  location = "West Europe"
}

resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

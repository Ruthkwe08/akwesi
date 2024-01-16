locals{
  lb=[for f in fileset("${path.module}/lbfolder", "[^_]*.yaml") : yamldecode(file("${path.module}/lbfolder/${f}"))]
  azurelb_list = flatten([
    for app in local.lb: [
      for one in try(app.listoflb, []) :{
        name=one.lbname
      }
    ]
])
}
resource "azurerm_resource_group" "examples" {
  name     = "LoadBalancerRG"
  location = "West Europe"
}

resource "azurerm_public_ip" "examples" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.examples.location
  resource_group_name = azurerm_resource_group.examples.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "examples" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.examples.location
  resource_group_name = azurerm_resource_group.examples.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.examples.id
  }
}

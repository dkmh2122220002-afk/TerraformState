resource "azurerm_virtual_network" "VNET01" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.Environment}-VirtualNetwork"
  address_space       = [var.VNET01, "172.16.0.0/16"]
  dns_servers         = [var.DNS01_IP, var.DNS02_IP]
}

resource "azurerm_subnet" "ZONE1_01" {
  name                 = "ZONE1_O1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET01.name
  address_prefixes     = [var.ZONE1.01]

}

resource "azurerm_subnet" "ZONE2_01" {
  name                 = "ZONE2_O1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET01.name
  address_prefixes     = [var.ZONE2.01]
}
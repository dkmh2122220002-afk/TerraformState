resource "azurerm_network_interface" "WEB_NIC01" {
  name                = "WEB_NIC01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    subnet_id                     = azurerm_subnet.ZONE1_01.id
    name                          = "WEB_NIC01_IP_Address"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
  }
}

resource "azurerm_network_interface" "DNS_NIC01" {
  name                = "DNS_NIC01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "DNS_NIC01_IP_Address"
    subnet_id                     = azurerm_subnet.ZONE2_01.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.DNS02_IP
  }
}
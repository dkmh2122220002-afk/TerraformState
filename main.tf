terraform {
  required_version = ">=1.15.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "1-163a8079-playground-sandbox"
    storage_account_name = "dkmh2122220002"
    container_name       = "terraform-state"
    key                  = "terraform-state.tfstate"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {

  }
}

resource "azurerm_resource_group" "rg" {
  name     = "1-163a8079-playground-sandbox"
  location = "East US"
}

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
  address_prefixes     = [var.ZONE1["01"]]

}

resource "azurerm_subnet" "ZONE2_01" {
  name                 = "ZONE2_O1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNET01.name
  address_prefixes     = [var.ZONE2["01"]]
}

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

resource "azurerm_network_security_group" "Allow_WEB" {
  name                = "NSG_Allow_WEB"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_network_security_rule" "Allow_WEB_Traffic" {
  name                        = "Allow_WEB_Traffic"
  priority                    = 100
  network_security_group_name = azurerm_network_security_group.Allow_WEB.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = var.ZONE1["01"]
  destination_port_ranges = [
    var.LIST_KNOWN_PORT["HTTP"],
    var.LIST_KNOWN_PORT["HTTPS"]
  ]
  protocol            = "Tcp"
  direction           = "Inbound"
  access              = "Allow"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "Allow_SSH_Traffic" {
  name                        = "Allow_SSH_Traffic"
  priority                    = 101
  network_security_group_name = azurerm_network_security_group.Allow_WEB.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = var.ZONE1["01"]
  destination_port_range      = var.LIST_KNOWN_PORT["SSH"]
  protocol                    = "Tcp"
  direction                   = "Inbound"
  access                      = "Allow"
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "Allow_DNS" {
  name                = "NSG_Allow_DNS"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rule {
    name                       = "Allow_DNS_Traffic"
    priority                   = 100
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = [var.LIST_KNOWN_PORT["DNS"], var.LIST_KNOWN_PORT["SSH"]]
    protocol                   = "Tcp"
    direction                  = "Inbound"
  }
}

resource "azurerm_subnet_network_security_group_association" "ZONE1_01_Allow_WEB" {
  subnet_id                 = azurerm_subnet.ZONE1_01.id
  network_security_group_id = azurerm_network_security_group.Allow_WEB.id
}

resource "azurerm_subnet_network_security_group_association" "ZONE2_01_Allow_DNS" {
  subnet_id                 = azurerm_subnet.ZONE2_01.id
  network_security_group_id = azurerm_network_security_group.Allow_DNS.id
}


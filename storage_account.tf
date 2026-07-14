resource "azurerm_storage_account" "dkmh2122220002" {
  name = "dkmh2122220002"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  #account_kind = ""
  account_tier = "Standard"
}
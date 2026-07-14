resource "azurerm_linux_virtual_machine" "WEB_SRV" {
  name = "${var.Environment}-WEBSRV"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  size = var.VM_SKU.WEB
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = var.Disk_Size.WEB
  }
  admin_username = "Hien"
  admin_password = "xinchao1A"
  disable_password_authentication = "false"
  source_image_reference {
    publisher = "canonical"
    offer = "ubuntu-26_04-lts"
    sku = "minimal-gen1"
    version = "latest"
  }
  network_interface_ids = [azurerm_network_interface.WEB_NIC01.id]
  boot_diagnostics {
    storage_account_uri = "https://${azurerm_storage_account.dkmh2122220002.name}.blob.core.windows.net/"
  }
  custom_data = base64encode(file("./WEB_init_script.sh"))
}

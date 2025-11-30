resource "azurerm_resource_group" "tfstate" {
  name     = "StorageRG"
  location = "Italy North"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "taskboardstorage${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "taskboardcontainer"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

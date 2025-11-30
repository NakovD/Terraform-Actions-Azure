provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "5a18b043-6235-475b-9d4e-9ec800627e19"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "StorageRG"
  location = "Italy North"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "taskboardstorage"
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

output "resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}

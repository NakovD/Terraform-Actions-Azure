terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.54.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "StorageRG"
    storage_account_name = "taskboardsadavidnakov"                              
    container_name       = "taskboardstoragedavid"                                
    key                  = "terraform.tfstate"                
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "5a18b043-6235-475b-9d4e-9ec800627e19"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "taskboard-rg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "taskboard-sp" {
  name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.taskboard-rg.name
  location            = azurerm_resource_group.taskboard-rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_app_service_source_control" "taskboard-app-source-control" {
  app_id                 = azurerm_linux_web_app.taskboard-app.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.taskboard-rg.name
  location                     = azurerm_resource_group.taskboard-rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  name                 = "${var.sql_database_name}${random_integer.ri.result}"
  server_id            = azurerm_mssql_server.server.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  sku_name             = "S0"
  max_size_gb          = 2
  zone_redundant       = false
  geo_backup_enabled   = false
  storage_account_type = "Local"

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_mssql_firewall_rule" "firewall-rule" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


resource "azurerm_linux_web_app" "taskboard-app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.taskboard-rg.name
  location            = azurerm_service_plan.taskboard-sp.location
  service_plan_id     = azurerm_service_plan.taskboard-sp.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};User ID=${azurerm_mssql_server.server.administrator_login};Password=${azurerm_mssql_server.server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True"
  }
}



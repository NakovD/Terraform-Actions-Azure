variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "App service plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "App service name in Azure"
}

variable "sql_server_name" {
  type        = string
  description = "SQL Server name in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "Database name in Azure"
}

variable "sql_admin_login" {
  type        = string
  description = "DB login name in Azure"
}

variable "sql_admin_password" {
  type        = string
  description = "DB login password in Azure"
}

variable "firewall_rule_name" {
  type        = string
  description = "Server Firewall rule name in Azure"
}

variable "repo_URL" {
  type        = string
  description = "Repo URL in github"
}

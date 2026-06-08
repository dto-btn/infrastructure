variable "name" {
  type        = string
  description = "The name of the PostgreSQL Flexible Server instance. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the PostgreSQL Flexible Server instance."
}
variable "location" {
  type        = string
  description = "The location in which to create the PostgreSQL Flexible Server instance."
}
variable "administrator_login" {
  type        = string
  description = "The administrator login for the PostgreSQL Flexible Server instance."
}
variable "administrator_password" {
  type        = string
  description = "The administrator password for the PostgreSQL Flexible Server instance."
  sensitive   = true
}
variable "postgresql_version" {
  default     = "16"
  description = "The version of PostgreSQL to use for the Flexible Server instance."
}
variable "storage_mb" {
  default     = 32768
  description = "The storage size in MB for the PostgreSQL Flexible Server instance."
}
variable "sku_name" {
  default     = "B_Standard_B1ms"
  description = "The SKU name for the PostgreSQL Flexible Server instance."
}
variable "database_name" {
  default     = "litellm_db"
  description = "The name of the default database to create in the PostgreSQL Flexible Server instance."
}

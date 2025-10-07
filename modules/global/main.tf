data "azurerm_resource_group" "rg"{
    name = var.resource_group_name
}

resource "azurerm_key_vault" "infrakv" {
  name                        = "${var.name_prefix}-kv"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id  #this to change?  abstract it out?
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard" 
}

# TODO: need access policy to add in PEM file.  Manually added in for now.

# #some default access policies maybe?
# resource "azurerm_key_vault_access_policy" "example-principal" {
#   key_vault_id = azurerm_key_vault.infrakv.id
#   tenant_id    = var.tenant_id
#   object_id    = 

#   key_permissions = [
#     "Get", "List", "Encrypt", "Decrypt"
#   ]
# }

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                = "${var.name_prefix}-analytics"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}



#storage accounts?
#Log analytics?
#separate into subfolders?  for finegrained dependency blocks?
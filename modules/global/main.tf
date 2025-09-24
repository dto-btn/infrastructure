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

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

#storage accounts?
#Log analytics?
#separate into subfolders?  for finegrained dependency blocks?
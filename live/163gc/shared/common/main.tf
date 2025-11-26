data "azurerm_resource_group" "infrastructureRG" {
  name = "ScSc-CIO_ECT_Infrastructure-rg"
}

resource "azurerm_container_registry" "acr" {
  name                = "ectacr"
  resource_group_name = data.azurerm_resource_group.infrastructureRG.name
  location            = data.azurerm_resource_group.infrastructureRG.location
  sku                 = "Basic"
  admin_enabled       = false
}
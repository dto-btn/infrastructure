/****************************************************
*                       RG                          *
*****************************************************/
resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-${var.project_name}-rg"
  location = var.default_location
}

/****************************************************
*              COGNITIVE SERVICE(S)                 *
*****************************************************/
resource "azurerm_cognitive_account" "main" {
  name                = "${var.name_prefix}-${var.project_name}-oai"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"

}

resource "azurerm_cognitive_deployment" "gpt" {
  name                 = "gpt-35-turbo-16k"
  cognitive_account_id = azurerm_cognitive_account.main.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo-16k"
    version = "0613"
  }

  scale {
    type = "Standard"
    capacity = 300
  }
}

resource "azurerm_cognitive_deployment" "gpt4" {
  name                 = "gpt-35-turbo-16k"
  cognitive_account_id = azurerm_cognitive_account.main.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "0613"
  }

  scale {
    type = "Standard"
    capacity = 40
  }
}

resource "azurerm_cognitive_deployment" "ada" {
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.main.id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }

  scale {
    type = "Standard"
    capacity = 350
  }
}

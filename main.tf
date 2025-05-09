provider "azurerm" {
  features {}
  subscription_id = "..."

}

resource "azurerm_resource_group" "main" {
  name     = "companyA-rg"
  location = "East US"
}


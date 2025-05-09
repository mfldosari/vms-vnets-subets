provider "azurerm" {
  features {}
  subscription_id = "ac2d458e-bde5-440e-86dc-d8312f7cb11a"

}

resource "azurerm_resource_group" "main" {
  name     = "companyA-rg"
  location = "East US"
}


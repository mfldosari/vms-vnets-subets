provider "azurerm" {
  features {}
  subscription_id = "..."

}

resource "azurerm_resource_group" "main" {
  depends_on = [null_resource.runS]
  name       = "companyA-rg"
  location   = "East US"
}

resource "null_resource" "runS" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "${path}/cleanJSON.sh"
  }
}
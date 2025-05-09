provider "azurerm" {
  features {}
  subscription_id = "...."

}

resource "azurerm_resource_group" "main" {
  name       = "companyA-rg"
  location   = "East US"
}

resource "null_resource" "run" {
  depends_on = [ azurerm_linux_virtual_machine.employee_vm ]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "bash ./shapeive.sh"
  }
}

# resource "null_resource" "runS" {
#   depends_on = [ 
#     azurerm_linux_virtual_machine.employee_vm,
#     null_resource.run
#      ]
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = "bash ./anisble.sh"
#   }
# }

# resource "null_resource" "runO" {
#     depends_on = [ azurerm_public_ip.ips ]
#   triggers = {
#     always_run = "${timestamp()}"
#   }
# provisioner "local-exec" {
#   command     = "terraform output -json > tf_output.json"
#   interpreter = ["bash", "-c"]  # Explicitly specify shell
# }
# }

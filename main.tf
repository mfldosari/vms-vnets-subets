provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

}


module "resource_group" {
  source = "./modules/general/resource_group"
  rg = var.rg
}

module "compute" {
  source = "./modules/compute"
  network_interface_ids = module.network.employee_nic_ids  
  rg_location = module.resource_group.rg_location
  rg_name = module.resource_group.rg_name
}




module "network" {
  depends_on          = [module.resource_group]
  source = "./modules/network"
  rg_location = module.resource_group.rg_location
  rg_name = module.resource_group.rg_name
}



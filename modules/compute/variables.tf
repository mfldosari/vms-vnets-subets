
variable "rg_name" {
  type        = string
  description = "rg name"
}

variable "rg_location" {
  type        = string
  description = "rg location"
}

variable "network_interface_ids" {
  description = "List of network interface IDs for employee VMs"
  type        = list(string)
}
variable "subscription_id" {
  type        = string
  description = "Subscription id"
  default     = ".."
}

variable "rg" {
  type        = map(string)
  description = "Resource Group location and name"
  default = {
    name     = "companyA-rg"
    location = "East US"
  }
}



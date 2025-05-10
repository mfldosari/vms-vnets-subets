locals {
  # Decode the JSON file into a list of employees
  employees_all       = jsondecode(file("Data/employees_cleaned.json"))
  employees_active_tf = { for emp in local.employees_all : emp.name => emp if emp.status == "active" }

  # Filter active employees and add formatted name
  employees_active = [
    for emp in local.employees_active_tf :
    {
      name             = emp.name
      email            = emp.email
      department       = emp.department
      status           = emp.status
      default_password = emp.default_password
      formatted_name   = "${substr(split(" ", emp.name)[0], 0, 1)}-${split(" ", emp.name)[1]}" # First letter of first name and full last name
    }
    if emp.status == "active"
  ]
}

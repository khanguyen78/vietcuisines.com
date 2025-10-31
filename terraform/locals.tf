locals {
  user = "vietcuisines"
  site = "vietcuisines.com"
  domain = "vietcuisines.com"
  cname = "www.vietcuisines.com"

  common_tags = {
    project = "vietcuisines"
    site = "vietcuisines.com"
    environment = "production"
    env = "prod"
    e = "p"
    ManagedByTerraform = true
  }
}

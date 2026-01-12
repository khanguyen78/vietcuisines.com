locals {
  cidr_block = "10.0.0.0/16"
  project = "vietcuisines.com"
  domain = "vietcuisines.com"
  cname = "www.vietcuisines.com"
  wildcard = "*.vietcuisines.com"
  region = "us-east-1"
  environment = "production"
  env = "prod"
  e = "p"
  iam_user = "github-vietcuisines.com"


  common_tags = {
    Project = "vietcuisines.com"
    RootDomain = "vietcuisines.com"
    Domain = "vietcuisines.com"
    CName = "www.vietcuisines.com"
    Environment = "production"
    Customer = "kqmap"
    Owner = "kqmap"
    ManagedByTerraform = "true"
  }
}

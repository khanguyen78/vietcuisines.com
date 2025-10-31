provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "qtn-tf"
    key    = "www.vietcuisines.com/prod/vietcuisinestf.tfstate"
    region = "us-east-1"
  }
}

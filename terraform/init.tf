provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "qtn-tf"
    key    = "vietcuisines.com/production/vietcuisines.com.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
  backend "s3" {
    bucket         = "c-39"
    key            = "state/terraform.state"
    region         = "us-east-1"
    dynamodb_table = "c_39"
  }

}


provider "aws" {
  region = "us-east-1"
}


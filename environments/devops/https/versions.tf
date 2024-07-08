terraform {
  required_version = "~> 1.8"
  backend "s3" {
    bucket         = "bucket-for-my-states"
    key            = "https/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
  }
  required_providers {
    aws = "~> 5.0"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform       = "Managed"
      Environment     = var.environment
      Terraform-state = var.terraform_state
    }
  }
}
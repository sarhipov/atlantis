terraform {
  required_version = "~>1.8.0"
  backend "s3" {
    bucket         = "terraform-state-devops-tools"
    key            = "ec2/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "devops-tools-terraform-lock"
  }
  required_providers {
    aws = {
      version = "~> 5.0"
    }
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
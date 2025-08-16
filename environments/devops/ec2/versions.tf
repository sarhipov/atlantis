terraform {
  required_version = "~> 1.12"
  backend "s3" {
    bucket       = "s3-bucket-for-terraform-states"
    key          = "devops/ec2/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
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
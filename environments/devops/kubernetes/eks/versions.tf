terraform {
  required_version = "~> 1.12"
  backend "s3" {
    bucket         = "s3-bucket-for-terraform-states"
    key            = "eks/terraform.tfstate"
    region         = "eu-north-1"
    use_lockfile = true
  }

  required_providers {
    aws       = "~> 6.0"
  }
}

provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = {
      Terraform       = "Managed"
      Environment     = var.environment
      Terraform-state = var.terraform_state
    }
  }
}
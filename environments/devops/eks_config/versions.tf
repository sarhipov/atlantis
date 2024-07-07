terraform {
  required_version = "~> 1.8.0"
  backend "s3" {
    bucket         = "bucket-for-my-states"
    key            = "eks_config/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
  }

  required_providers {
    aws        = "~> 5.0"
    helm       = "~> 2.0"
    kubernetes = "~> 2.0"
  }
}

provider "helm" {
  kubernetes {
    config_path = "../eks/kubeconfig_${var.cluster_name}"
  }
}

provider "kubernetes" {
  config_path = "../eks/kubeconfig_${var.cluster_name}"

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
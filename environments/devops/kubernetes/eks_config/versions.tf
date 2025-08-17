terraform {
  required_version = "~> 1.12"
  backend "s3" {
    bucket         = "s3-bucket-for-terraform-states"
    key            = "devops/kubernetes/eks_config/terraform.tfstate"
    region         = "eu-north-1"
  }

  required_providers {
    aws        = "~> 6.0"
    helm       = "~> 3.0"
    kubernetes = "~> 2.0"
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec = {
      api_version = local.eks_config.exec.api_version
      args        = local.eks_config.exec.args
      command     = local.eks_config.exec.command
    }
  }
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = local.eks_config.exec.api_version
    args        = local.eks_config.exec.args
    command     = local.eks_config.exec.command
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
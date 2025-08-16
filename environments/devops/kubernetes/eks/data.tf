data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket_name
    key    = "devops/network/vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "eks_optimized_arm64_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-arm64-standard-${var.kubernetes_version}-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}
/// main.tf
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ssm_parameter" "github_hostname" {
  name = "/atlantis/github_hostname"
}

data "aws_ssm_parameter" "github_secret" {
  name = "/atlantis/github_secret"
}

data "aws_ssm_parameter" "github_token" {
  name = "/atlantis/github_token"
}

data "aws_ssm_parameter" "github_user" {
  name = "/atlantis/github_user"
}

/// providers.tf
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}
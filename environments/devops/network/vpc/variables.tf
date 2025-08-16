variable "environment" {}
variable "region" {}
variable "cluster_name" {}
variable "terraform_state" {}

/// VPC
variable "vpc_configs" {
  type = any
}
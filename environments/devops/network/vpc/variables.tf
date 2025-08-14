variable "environment" {}
variable "region" {}
variable "cluster_name" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

/// VPC
variable "vpc_configs" {
  type = any
}
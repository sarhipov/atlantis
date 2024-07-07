/// General
variable "environment" {}
variable "region" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}
variable "dynamodb_table_name" {}

// Cluster configuration
variable "cluster_name" {}
variable "cluster_version" {}
variable "arm_instance_types" {
  default = ["m7g.large"]
}
variable "arm_ami_type" {
  default = "AL2023_ARM_64_STANDARD"
}
variable "x86_instance_types" {
  default = ["m7i.large"]
}
variable "x86_ami_type" {
  default = "AL2023_x86_64_STANDARD"
}

/// Users
variable "eks-users" {}
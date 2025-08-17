variable "environment" {}
variable "region" {}
variable "cluster_name" {}
variable "terraform_state" {}

/// Parameters
variable "ssm_parameters" {
  description = "Map of SSM parameters to create"
  type = any
}
/// General
variable "environment" {}
variable "region" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

// Security Groups
variable "security_groups" {
  type = any
}

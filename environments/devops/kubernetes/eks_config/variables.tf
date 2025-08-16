/// General
variable "environment" {}
variable "region" {}
variable "cluster_name" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

/// Other
variable "repo_secrets" {}
variable "repo" {}

/// aws-load-balancer-controller
variable "aws_load_balancer_controller_chart_version" {
  type    = string
  default = ""
}

variable "aws_load_balancer_controller_namespace" {
  type    = string
  default = "kube-system"
}

variable "aws_load_balancer_controller_service_account_name" {
  type    = string
  default = "aws-load-balancer-controller-sa"
}

/// atlantis
variable "atlantis_chart_version" {
  type    = string
  default = ""
}

variable "atlantis_namespace" {
  type    = string
  default = "atlantis"
}

variable "atlantis_service_account_name" {
  type    = string
  default = "atlantis-sa"
}

variable "atlantis_url" {
  type        = string
  description = "Public URL for Atlantis server (used for GitHub webhooks)"
  default     = "atlantis.example.com"
}
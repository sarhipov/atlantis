variable "environment" {}
variable "region" {}
variable "cluster_name" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

/// VPC
variable "vpc_configs" {
  type = map(object({
    cidr                 = string
    description          = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    subnets              = map(object({
      availability_zone = string
      cidr              = string
      public            = optional(bool, false)
      nat_gw            = optional(bool, false)
      description       = string
    }))
    endpoints           = optional(map(object({})), {})
  }))
}
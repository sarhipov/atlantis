/// General
variable "environment" {}
variable "region" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

// Security Groups
variable "security_groups" {
  type = map(object({
    ingress     = map(object({
      cidr_ipv4   = string
      from_port   = number
      ip_protocol = string
      to_port     = number
      description = optional(string)
    }))
    egress      = map(object({
      cidr_ipv4   = string
      from_port   = number
      ip_protocol = string
      to_port     = number
      description = string
    }))
    description = optional(string)
  }))
  default = {}
}

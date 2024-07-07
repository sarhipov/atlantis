variable "environment" {}
variable "vpc_name" {}
variable "vpc_config" {
  type = object({
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
  })
}
variable "create_igw" {
  type    = bool
  default = false
}
variable "cluster_name" {}
variable "tags" {}
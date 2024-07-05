variable "tags" {
  type    = map(string)
  default = {}
}
variable "environment" {}

variable "security_groups" {}
variable "vpc_id" {}
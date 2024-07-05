#provider "aws" {
#  default_tags {
#    tags = merge({
#      Terraform   = "Managed"
#      Environment = var.environment
#      }, var.tags
#    )
#  }
#  region = var.region
#}

// VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config.cidr
  enable_dns_support   = var.vpc_config.enable_dns_support
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames

  tags = merge(
    tomap(
      {
        "Name" = var.vpc_name
      }
    ),
    var.tags
  )
}

/// Internet GW and default route to VPCs default Route table
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.vpc_name}-igw" }
  )
}
// VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0.1"

  /// General config
  name = var.vpc_name
  cidr = var.vpc_config.cidr
  azs  = local.azs

  /// Public subnets 
  public_subnets = [
    for i in range(var.vpc_config.num_of_azs) : 
    cidrsubnet(var.vpc_config.cidr, var.vpc_config.public_subnet.size, i + 1)
  ]
  map_public_ip_on_launch = true
  public_subnet_tags = var.vpc_config.public_subnet.tags

  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  enable_dns_support   = var.vpc_config.enable_dns_support

  /// Internet GW
  create_igw = var.vpc_config.create_igw
  igw_tags = {
    Name = "${var.vpc_name}-igw"
  }

  /// NAT GW
  enable_nat_gateway     = var.vpc_config.enable_nat_gateway
  single_nat_gateway     = var.vpc_config.single_nat_gateway
  one_nat_gateway_per_az = var.vpc_config.one_nat_gateway_per_az

  /// Tags
  tags = local.common_tags
}
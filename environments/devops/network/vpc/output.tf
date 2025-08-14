output "vpcs" {
  value = {
    for vpc_name, vpc_module in module.vpc :
    vpc_name => vpc_module.vpc_info
  }
}

output "vpc_ids" {
  value = {
    for vpc_name, vpc_module in module.vpc :
    vpc_name => vpc_module.vpc_id
  }
}

output "public_subnets" {
  value = {
    for vpc_name, vpc_module in module.vpc :
    vpc_name => vpc_module.public_subnets
  }
}
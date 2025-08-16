output "vpcs" {
  value = {
    for vpc_name, vpc_module in module.vpc :
    vpc_name => vpc_module.vpc_info
  }
}
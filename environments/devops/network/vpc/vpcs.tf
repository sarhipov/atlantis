module "vpc" {
  for_each = var.vpc_configs
  
  source = "../../../../modules/vpc"

  environment = var.environment
  vpc_name    = each.key
  vpc_config  = each.value
}
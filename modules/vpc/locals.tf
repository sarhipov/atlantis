locals {
  az_suffixes = ["a", "b", "c", "d", "e", "f"]
  azs         = [for i in range(var.vpc_config.num_of_azs) : "${data.aws_region.current.id}${local.az_suffixes[i]}"]

  common_tags = merge({
    Environment = var.environment
    Region      = data.aws_region.current.id
  },
    var.vpc_config.tags
  )
}
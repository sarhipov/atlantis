locals {
  common_tags = merge({
    Environment = var.environment
    Region      = data.aws_region.current.name
  },
    var.tags
  )
}
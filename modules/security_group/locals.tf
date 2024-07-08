locals {
  common_tags = merge({
    Environment = var.environment
  },
    var.tags
  )
}
output "main-vpc" {
  value = module.main-vpc.vpc_info
}

output "main-vpc_subnets" {
  value = module.main-vpc.subnet_info
}

output "main-vpc_eks-worker-subnets" {
  value = local.main-vpc_eks-workers_subnet_info
}
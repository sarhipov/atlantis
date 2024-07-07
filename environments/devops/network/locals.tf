locals {
  main-vpc_eks-workers_subnet_info = values({
    for key, subnet in module.main-vpc.subnet_info :
    key => subnet
    if startswith(key, "eks-workers")
  })
}
locals {
  subnet = data.terraform_remote_state.network.outputs.main-vpc_eks-worker-subnets[0].id
}
locals {
  subnet = data.terraform_remote_state.network.outputs.vpcs.main.public_subnets[0]
}
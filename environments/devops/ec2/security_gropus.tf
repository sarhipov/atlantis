module "test-ec2-security-groups" {
  source      = "../../../modules/security_group"
  environment = var.environment
  vpc_id      = data.terraform_remote_state.network.outputs.main-vpc.id

  security_groups = var.security_groups

  tags = {
    "Terraform-state" = "network/module.main-vpc-security-groups"
  }
}
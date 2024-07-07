module "main-vpc" {
  source = "../../../modules/vpc"

  //mandatory config
  environment = var.environment
  vpc_name    = "main"
  vpc_config  = var.vpc_configs["main"]

  create_igw = true

  // optional config
  tags = {
    "Terraform-state" = "network/main-vpc"
  }
  cluster_name = var.cluster_name
}
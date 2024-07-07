data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket_name
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

data "aws_caller_identity" "current" {}
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket_name
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

data "aws_ami" "arm" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon's AWS account ID for Amazon Linux AMIs
}
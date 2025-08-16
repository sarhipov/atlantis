module "test-ec2-security-groups" {
  source      = "../../../modules/security_group"
  environment = var.environment
  vpc_id      = data.terraform_remote_state.network.outputs.vpcs.main.vpc_id

  security_groups = var.security_groups

  tags = {
    "Terraform-state" = "network/module.main-vpc-security-groups"
  }
}

resource "aws_key_pair" "my-key" {
  key_name   = "sergei-key"
  public_key = file("${path.module}/files/sarhipov.pub")
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.arm.id
  instance_type = "t4g.small"
  key_name      = aws_key_pair.my-key.key_name

  subnet_id                   = local.subnet
  vpc_security_group_ids      = [module.test-ec2-security-groups.aws_security_group_info["test-ec2"].id]
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "test ec2 instance"
  }
}

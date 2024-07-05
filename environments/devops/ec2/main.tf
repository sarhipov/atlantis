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

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "test ec2 instance"
  }
}
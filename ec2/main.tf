resource "aws_key_pair" "my-key" {
  key_name   = "sergei-key"
  public_key = file("${path.module}/files/sarhipov.pub")
}

resource "aws_instance" "ec2" {
  ami           = "ami-049404f443332ea15" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t4g.small"
  key_name      = aws_key_pair.my-key.key_name

  subnet_id                   = "subnet-00cc9e1b5df6d904d"
  vpc_security_group_ids      = ["sg-058af7c15d154434c"]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "test ec2 instance"
  }
}
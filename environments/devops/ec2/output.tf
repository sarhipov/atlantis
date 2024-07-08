output "ec2_ips" {
  value = {
    private_ip = aws_instance.ec2.private_ip
    public_ip  = aws_instance.ec2.public_ip
  }
}
output "vpc_info" {
  value = aws_vpc.vpc
}

output "subnet_info" {
  value = aws_subnet.subnet
}

output "igw_info" {
  value = aws_internet_gateway.main
}
/// General
environment          = "devops-tools"
region               = "eu-north-1"
terraform_state      = "network/vpc"
cluster_name         = "devops-cluster"
tf_state_bucket_name = "bucket-for-my-states"

/// VPC
vpc_configs = {
  main = {
    description = "main VPC for tools"
    cidr        = "10.1.0.0/16"
    num_of_azs  = 2  # number of subnets to be created

    public_subnet = {
      size = 6  # /16 + size = subnet_size, if size = 6, then subnets will be /22
      tags = {
       "kubernetes.io/role/elb"                = "1"
       "kubernetes.io/cluster/devops-cluster" = "owned"
      }
    }

    enable_dns_support     = true
    enable_dns_hostnames   = true

    create_igw             = true
    enable_nat_gateway     = false
    single_nat_gateway     = false
    one_nat_gateway_per_az = false

    tags = {
      "Terraform-state" = "network/main-vpc"
    }
    cluster_name = "devops-cluster"
  },
}
/// General
environment          = "devops-tools"
region               = "eu-north-1"
terraform_state      = "network"
cluster_name         = "devops-cluster"
tf_state_bucket_name = "bucket-for-my-states"

/// VPC
vpc_configs = {
  main = {
    cidr                 = "10.1.0.0/16"
    description          = "main VPC for tools"
    enable_dns_support   = true
    enable_dns_hostnames = true
    subnets              = {
      eks-workers-1 = {
        availability_zone = "eu-north-1a"
        cidr              = "10.1.1.0/24"
        public            = true
        description       = "subnet for EKS workers and controlplane in AZ us-west-2a"
      },
      eks-workers-2 = {
        availability_zone = "eu-north-1b"
        cidr              = "10.1.101.0/24"
        public            = true
        description       = "subnet for EKS workers and controlplane in AZ us-west-2b"
      },
    }
    endpoints = {}
  }
}
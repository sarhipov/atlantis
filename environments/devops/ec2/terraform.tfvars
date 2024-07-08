/// General
environment          = "devops-tools"
region               = "eu-north-1"
terraform_state      = "ec2"
tf_state_bucket_name = "bucket-for-my-states"

security_groups = {
  test-ec2 = {
    ingress = {
      allow_all_inbound = {
        cidr_ipv4   = "0.0.0.0/0"
        from_port   = "-1"
        ip_protocol = "-1"
        to_port     = "-1"
        description = "Allow all inbound"
      },
    }
    egress = {
      allow_all_outbound = {
        cidr_ipv4   = "0.0.0.0/0"
        from_port   = "-1"
        ip_protocol = "-1"
        to_port     = "-1"
        description = "Allow all outbound"
      },
    }
    description = "Security group for test-ec2"
  },
}
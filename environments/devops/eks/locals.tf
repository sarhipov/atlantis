locals {
  kubeconfig_template_vars = {
    kubeconfig_name                = var.cluster_name
    endpoint                       = module.eks-cluster.cluster_endpoint
    cluster_auth_base64            = module.eks-cluster.cluster_certificate_authority_data
    aws_client_auth_api_version    = "client.authentication.k8s.io/v1beta1"
    aws_authenticator_command      = "aws-iam-authenticator"
    aws_authenticator_command_args = "        - ${join(
      "\n        - ", formatlist("\"%s\"", ["token", "-i", module.eks-cluster.cluster_name]),
    )}"
  }
  security_group_rules = {
    ingress = {
      allow_all = {
        description = "Allow all ingress"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    egress = {
      allow_all = {
        description = "Allow all egress"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}
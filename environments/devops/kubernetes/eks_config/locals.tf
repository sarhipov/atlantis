locals {
    eks_config = {
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }

  github_access_credentials = {
    hostname = data.aws_ssm_parameter.github_hostname.value
    secret   = data.aws_ssm_parameter.github_secret.value
    token    = data.aws_ssm_parameter.github_token.value
    user     = data.aws_ssm_parameter.github_user.value
  }
}
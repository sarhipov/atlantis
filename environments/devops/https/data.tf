data "aws_lb" "atlantis" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.cluster_name
  }
}

data "aws_lb_target_group" "atlantis" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.cluster_name
  }
}

data "aws_security_group" "atlantis_alb" {
  tags = {
    "ingress.k8s.aws/resource" = "ManagedLBSecurityGroup"
  }
}
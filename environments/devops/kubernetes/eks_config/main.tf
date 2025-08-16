resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  chart            = "aws-load-balancer-controller"
  version          = var.aws_load_balancer_controller_chart_version
  namespace        = var.aws_load_balancer_controller_namespace
  repository       = "https://aws.github.io/eks-charts"
  create_namespace = false

  values = [
    templatefile("${path.module}/values/aws-load-balancer-controller.yaml", {
      eks_cluster_name     = var.cluster_name
      service_account_name = var.aws_load_balancer_controller_service_account_name
      aws_region          = data.aws_region.current.id
    })
  ]
}

module "aws_load_balancer_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name                            = "${var.cluster_name}-aws-lbc-pdi"
  use_name_prefix                 = false
  attach_aws_lb_controller_policy = true
  policy_name_prefix              = "${var.cluster_name}_"

  associations = {
    one = {
      cluster_name    = var.cluster_name
      namespace       = "kube-system"
      service_account = var.aws_load_balancer_controller_service_account_name
    }
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  version    = var.atlantis_chart_version

  namespace        = var.atlantis_namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/values/atlantis.yaml", {
      user            = local.github_access_credentials.user
      token           = local.github_access_credentials.token
      secret          = local.github_access_credentials.secret
      hostname        = local.github_access_credentials.hostname
      allowed_repos   = var.repo
      service_account = var.atlantis_service_account_name
      atlantis_url    = var.atlantis_url
      aws_region      = data.aws_region.current.id
    })
  ]

  depends_on = [
    module.aws_load_balancer_controller_pod_identity,
    module.atlantis_pod_identity
  ]
}

module "atlantis_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name            = "${var.cluster_name}-atlantis-pdi"
  use_name_prefix = false

  # Atlantis needs broad permissions for Terraform operations
  additional_policy_arns = {
    "S3TerraformState" = aws_iam_policy.atlantis_s3_policy.arn,
    "TerraformAdmin"   = aws_iam_policy.atlantis_terraform_policy.arn
  }

  associations = {
    atlantis = {
      cluster_name    = var.cluster_name
      namespace       = var.atlantis_namespace
      service_account = var.atlantis_service_account_name
    }
  }
}

# S3 policy for Terraform state access
resource "aws_iam_policy" "atlantis_s3_policy" {
  name        = "${var.cluster_name}-atlantis-s3-policy"
  description = "IAM policy for Atlantis to access Terraform state bucket"
  policy      = file("${path.module}/values/atlantis-s3-policy.json")
}

# Terraform admin policy for Atlantis operations
resource "aws_iam_policy" "atlantis_terraform_policy" {
  name        = "${var.cluster_name}-atlantis-terraform-policy"
  description = "IAM policy for Atlantis Terraform operations"
  policy      = file("${path.module}/values/atlantis-terraform-policy.json")
}
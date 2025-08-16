
/// Pod-identity
module "aws_ebs_csi_pod_identity" {
  count                     = contains(keys(var.addons), "aws-ebs-csi-driver") ? 1 : 0
  source                    = "terraform-aws-modules/eks-pod-identity/aws"
  version                   = "~> 2.0"
  name                      = "${var.cluster_name}-aws-ebs-csi-pdi"
  use_name_prefix           = false
  policy_name_prefix        = "${var.cluster_name}_"
  attach_aws_ebs_csi_policy = true

  # additional_policy_arns = {
  #   "AmazonEBSCSIDriverPolicy" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  # }


  depends_on = [
    module.eks-cluster.cluster_name
  ]
}

module "aws_vpc_cni_ipv4_pod_identity" {
  count                     = contains(keys(var.addons), "vpc-cni") ? 1 : 0
  source                    = "terraform-aws-modules/eks-pod-identity/aws"
  version                   = "~> 2.0"
  name                      = "${var.cluster_name}-aws-vpc-cni-pdi"
  use_name_prefix           = false
  attach_aws_vpc_cni_policy = true
  policy_name_prefix        = "${var.cluster_name}_"
  aws_vpc_cni_enable_ipv4   = true

  depends_on = [
    module.eks-cluster.cluster_name
  ]
}

module "external_dns_pod_identity" {
  count   = contains(keys(var.addons), "external-dns") ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name                          = "${var.cluster_name}-external-dns-pdi"
  use_name_prefix               = false
  attach_external_dns_policy    = true
  policy_name_prefix            = "${var.cluster_name}_"
  external_dns_hosted_zone_arns = [] # Add your hosted zone ARNs here

  associations = {
    one = {
      cluster_name    = var.cluster_name
      namespace       = "external-dns"
      service_account = "external-dns"
    }
  }
  depends_on = [
    module.eks-cluster.cluster_name
  ]
}

module "cert_manager_pod_identity" {
  count                         = contains(keys(var.addons), "cert-manager") ? 1 : 0
  source                        = "terraform-aws-modules/eks-pod-identity/aws"
  version                       = "~> 2.0"
  name                          = "${var.cluster_name}-cert-manager-pdi"
  use_name_prefix               = false
  attach_cert_manager_policy    = true
  policy_name_prefix            = "${var.cluster_name}_"
  cert_manager_hosted_zone_arns = ["*"]

  associations = {
    one = {
      cluster_name    = var.cluster_name
      namespace       = "cert-manager"
      service_account = "cert-manager"
    }
  }
  depends_on = [
    module.eks-cluster.cluster_name
  ]
}

/// IAM Users for EKS cluster
resource "aws_iam_user" "eks-user" {
  for_each = var.eks-users
  name     = each.key
}
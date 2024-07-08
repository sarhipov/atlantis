module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  /// Cluster configuration
  /// General
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  /// Network
  vpc_id                   = data.terraform_remote_state.network.outputs.main-vpc.id
  subnet_ids               = data.terraform_remote_state.network.outputs.main-vpc_eks-worker-subnets[*].id
  control_plane_subnet_ids = data.terraform_remote_state.network.outputs.main-vpc_eks-worker-subnets[*].id

  /// Access
  iam_role_name                            = "devops-cluster"
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    /// NOTE this is dummy user, without proper permissions
    admin = {
      principal_arn       = aws_iam_user.eks-user["admin-user"].arn
      policy_associations = {
        cluster_admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    /// NOTE this is dummy user, without proper permissions
    read_only = {
      principal_arn       = aws_iam_user.eks-user["read-only-user"].arn
      policy_associations = {
        cluster_read_only = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  create_iam_role          = true
  iam_role_use_name_prefix = true

  iam_role_additional_policies = {}

  /// Security
  #  cluster_security_group_id = var.cluster_security_group_id
  cluster_security_group_name             = "${var.cluster_name}-controlplane-additional-sg"
  cluster_security_group_description      = "Additional Security Group for ${var.cluster_name} controlplane"
  cluster_security_group_use_name_prefix  = false
  cluster_security_group_additional_rules = {
    ingress_all = local.security_group_rules.ingress.allow_all
    egress_all  = local.security_group_rules.egress.allow_all
  }

  #  node_security_group_id = var.node_security_group_id
  node_security_group_name             = "${var.cluster_name}-worker-nodes-sg"
  node_security_group_description      = "Security group for all worker nodes in the ${var.cluster_name}"
  node_security_group_use_name_prefix  = false
  node_security_group_additional_rules = {
    ingress_all = local.security_group_rules.ingress.allow_all
    egress_all  = local.security_group_rules.egress.allow_all
  }

  /// Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  /// Addons
  cluster_addons = {
    coredns = {
      addon_version     = "v1.11.1-eksbuild.9"
      resolve_conflicts = "OVERWRITE"
    }
    eks-pod-identity-agent = {
      addon_version     = "v1.3.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = "v1.30.0-eksbuild.3"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version     = "v1.18.2-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = "v1.32.0-eksbuild.1"
    }
  }

  /// Workers configuration
  eks_managed_node_group_defaults = {}
  eks_managed_node_groups         = {
    arm-workers = {
      create_launch_template          = true
      launch_template_name            = "${var.cluster_name}-arm-workers"
      launch_template_use_name_prefix = false

      ami_type       = var.arm_ami_type
      instance_types = var.arm_instance_types

      min_size          = 2
      max_size          = 4
      desired_size      = 2
      ebs_optimized     = true
      enable_monitoring = true

      create_iam_role              = true
      iam_role_use_name_prefix     = false
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEKS_CNI_Policy              = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        ALBIngressControllerIAMPolicy     = aws_iam_policy.ALBIngressControllerIAMPolicy.arn
        AmazonS3_TF_StatePolicy           = aws_iam_policy.tf_state_s3_bucket_policy.arn
        AmazonDynamoDB_TF_StateLockPolicy = aws_iam_policy.tf_state_lock_dynamodb_access_policy.arn
        AtlantisIAMPolicy                 = aws_iam_policy.AtlantisIAMPolicy.arn
      }
      protect_from_scale_in = true
    }
  }
}
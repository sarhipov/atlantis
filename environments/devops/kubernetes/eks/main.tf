module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  /// Cluster configuration
  /// General
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  /// Network
  vpc_id                   = data.terraform_remote_state.network.outputs.vpcs.main.vpc_id
  subnet_ids               = data.terraform_remote_state.network.outputs.vpcs.main.public_subnets

  /// Access
  iam_role_name                            = "devops-cluster"
  endpoint_public_access                   = var.endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

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

  iam_role_use_name_prefix = true

  iam_role_additional_policies = {}

  /// Security
  #  cluster_security_group_id = var.cluster_security_group_id
  security_group_name             = "${var.cluster_name}-controlplane-additional-sg"
  security_group_description      = "Additional Security Group for ${var.cluster_name} controlplane"
  security_group_use_name_prefix  = false
  security_group_additional_rules = var.security_group_additional_rules

  #  node_security_group_id = var.node_security_group_id
  node_security_group_name             = "${var.cluster_name}-worker-nodes-sg"
  node_security_group_description      = "Security group for all worker nodes in the ${var.cluster_name}"
  node_security_group_use_name_prefix  = false
  node_security_group_additional_rules = var.node_security_group_additional_rules

  /// Logging
  enabled_log_types = var.enabled_log_types

  /// Addons
  addons = local.cluster_addons

  /// Nodes configuration
  eks_managed_node_groups         = {
    arm-workers = {
      /// Launch template
      create_launch_template          = true
      launch_template_use_name_prefix = false
      launch_template_name            = "${var.cluster_name}-arm-node-lt"
      launch_template_tags = {
        Name = "${var.cluster_name}-arm-node"
      }

      /// Metadata service configuration for AWS Load Balancer Controller
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"  # IMDSv2
        http_put_response_hop_limit = 2           # Required for LBC metadata introspection
        instance_metadata_tags      = "enabled"
      }

      /// Volumes
      ebs_optimized = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypted             = true
            volume_size           = 50
            volume_type           = "gp3"
          }
        }
      }

      ///ASG
      name          = "${var.cluster_name}-arm-node-asg"
      ami_type      = "AL2023_ARM_64_STANDARD"
      capacity_type = "SPOT"

      instance_types = [
        "t4g.large",
        "c6g.large",
        "c7g.large",
        "c8g.large",
        "c6gd.large",
        "c7gd.large",
        "m6g.large",
        "m7g.large",
        "m8g.large",
        "r6g.large",
        "r7g.large",
        "r8g.large"
      ]

      min_size          = 1
      max_size          = 2
      desired_size      = 2
      ebs_optimized     = true
      enable_monitoring = true

      /// Spot instance configuration

      create_iam_role              = true
      iam_role_use_name_prefix     = false
      iam_instance_profile_name = "${var.cluster_name}-arm-node-instace-profile"
      iam_role_name             = "${var.cluster_name}-arm-node-role"
      iam_role_additional_policies = {
        "AmazonEKSWorkerNodePolicy"          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "AmazonEKS_CNI_Policy"               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "AmazonEC2ContainerRegistryReadOnly" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "AmazonSSMManagedInstanceCore"       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        # "AWSLoadBalancerControllerNodePolicy" = aws_iam_policy.aws_load_balancer_controller.arn # replaced by pod identity
      }
      protect_from_scale_in = true

     /// Security groups
    create_security_group = false


    /// cloud init
    cloudinit_post_nodeadm = [
      {
        content_type = "application/node.eks.aws"
        content      = <<-EOT
            ---
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  maxPods: 110
          EOT
      }
    ]

      tags = {
        "Name" = "${var.cluster_name}-arm-nodes"
      }
    },
  }
}
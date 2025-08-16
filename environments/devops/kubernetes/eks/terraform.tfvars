/// General
environment          = "devops-tools"
terraform_state      = "kubernetes/eks"
tf_state_bucket_name = "s3-bucket-for-terraform-states"

/// EKS cluster
kubernetes_version     = "1.33"
cluster_name           = "devops-cluster"
endpoint_public_access = true
/// EKS users
/// NOTE those are dummy user with dummy policies that will be attached to EKS
eks-users ={
  admin-user = {
    policy_name =  "eks-admins-policy"
    description = "Admin user for EKS cluster"
  },
  read-only-user = {
    policy_name =  "eks-readonly-users-policy"
    description = "Read only user for EKS cluster"
  }
}

/// Security Group Rules
security_group_additional_rules = {
  ingress_all = {
    description = "Allow all ingress traffic"
    type        = "ingress"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress_all = {
    description = "Allow all egress traffic"
    type        = "egress"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

node_security_group_additional_rules = {
  ingress_all = {
    description = "Allow all ingress traffic"
    type        = "ingress"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress_all = {
    description = "Allow all egress traffic"
    type        = "egress"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/// EKS Addons
addons = {
  eks-pod-identity-agent = {
    addon_version     = "v1.3.8-eksbuild.2"
    resolve_conflicts = "OVERWRITE"
  },
  kube-proxy = {
    addon_version     = "v1.33.3-eksbuild.4"
    resolve_conflicts = "OVERWRITE"
  },
  vpc-cni = {
    addon_version     = "v1.20.1-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  },
  coredns = {
    addon_version     = "v1.12.2-eksbuild.4"
    resolve_conflicts = "OVERWRITE"
  },
  eks-node-monitoring-agent = {
    addon_version     = "v1.4.0-eksbuild.2"
    resolve_conflicts = "OVERWRITE"
  },
  metrics-server = {
    addon_version     = "v0.8.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  },
  kube-state-metrics = {
    addon_version     = "v2.16.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  },
  cert-manager = {
    addon_version     = "v1.18.2-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  },
  aws-ebs-csi-driver = {
    addon_version     = "v1.47.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  },
}
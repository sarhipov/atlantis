locals {
  # Define which addons support pod identity
  pod_identity_addons = {
    "vpc-cni" = {
      service_account = "aws-node"
      namespace      = "kube-system"
    }
    "aws-ebs-csi-driver" = {
      service_account = "ebs-csi-controller-sa"  
      namespace       = "kube-system"
    }
  }

  cluster_addons = {
    for addon_name, addon_config in var.addons : addon_name => merge(
      {
        addon_version        = try(addon_config.addon_version, null)
        configuration_values = jsonencode(try(addon_config.configuration_values, {}))
        resolve_conflicts = try(addon_config.resolve_conflicts, "OVERWRITE")
      },
      # Add pod identity association if this addon supports it and pod identity exists
      contains(keys(local.pod_identity_addons), addon_name) ? {
        pod_identity_association = addon_name == "vpc-cni" && length(module.aws_vpc_cni_ipv4_pod_identity) > 0 ? [
          {
            role_arn        = module.aws_vpc_cni_ipv4_pod_identity[0].iam_role_arn
            service_account = local.pod_identity_addons[addon_name].service_account
          }
        ] : addon_name == "aws-ebs-csi-driver" && length(module.aws_ebs_csi_pod_identity) > 0 ? [
          {
            role_arn        = module.aws_ebs_csi_pod_identity[0].iam_role_arn
            service_account = local.pod_identity_addons[addon_name].service_account
          }
        ] : []
      } : {}
    )
  }
}
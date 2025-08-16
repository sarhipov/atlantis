/// General
variable "environment" {}
variable "terraform_state" {}
variable "tf_state_bucket_name" {}

// Cluster configuration
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "endpoint_public_access" {
  default = false
}
variable "enable_cluster_creator_admin_permissions" {
  default = true
}
variable "enabled_log_types" {
  default = []
}
variable "arm_instance_types" {
  default = ["t4g.medium"]
}
variable "arm_ami_type" {
  default = "AL2023_ARM_64_STANDARD"
}
variable "x86_instance_types" {
  default = ["m7i.large"]
}
variable "x86_ami_type" {
  default = "AL2023_x86_64_STANDARD"
}

/// Users
variable "eks-users" {}

/// Security Group Rules
variable "security_group_additional_rules" {
  description = "Map of additional security group rules for EKS control plane"
  type        = map(any)
  default     = {}
}

variable "node_security_group_additional_rules" {
  description = "Map of additional security group rules for EKS worker nodes"
  type        = map(any)
  default     = {}
}

variable "addons" {
  description = "Map of cluster addon configurations"
  type        = any
  default     = {}
}
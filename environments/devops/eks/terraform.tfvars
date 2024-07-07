/// General
environment          = "devops-tools"
region               = "eu-north-1"
terraform_state      = "eks"
tf_state_bucket_name = "bucket-for-my-states"
dynamodb_table_name  = "terraform-state-lock"

/// EKS cluster
cluster_version   = "1.30"
cluster_name      = "devops-cluster"

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
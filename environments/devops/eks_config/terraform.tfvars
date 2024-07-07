/// General
environment          = "devops-tools"
region               = "eu-north-1"
cluster_name         = "devops-cluster"
terraform_state      = "eks_config"
tf_state_bucket_name = "bucket-for-my-states"
dynamodb_table_name  = "terraform-state-lock"

/// Other
repo_secrets = "github-access-credentials" /// name of the secret stored in AWS Secrets Manager
repo         = "github.com/sarhipov/*"
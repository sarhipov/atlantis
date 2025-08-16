/// General
environment          = "devops-tools"
region               = "eu-north-1"
cluster_name         = "devops-cluster"
terraform_state      = "eks_config"
tf_state_bucket_name = "s3-bucket-for-terraform-states"

/// Other
repo_secrets = "github-access-credentials" /// name of the secret stored in AWS Secrets Manager
repo         = "github.com/sarhipov/*"

///helm charts
aws_load_balancer_controller_chart_version = "1.13.1"
atlantis_chart_version                     = "5.18.1"

///atlantis
atlantis_namespace            = "atlantis"
atlantis_service_account_name = "atlantis-sa"
atlantis_url                  = "atlantis.devops-cluster.local"
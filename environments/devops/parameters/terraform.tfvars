/// General
environment          = "devops-tools"
region               = "eu-north-1"
terraform_state      = "parameters"
cluster_name         = "devops-cluster"

//// Parameters
ssm_parameters = {
  "atlantis/github_hostname" = {
    value = "github.com"
    type  = "SecureString"
  }
  "atlantis/github_secret" = {
    value = ""
    type  = "SecureString"
  }
  "atlantis/github_token" = {
    value = "YOUR_TOKEN_HERE" #TODO add real token generated in github
    type  = "SecureString"
  }
  "atlantis/github_user" = {
    value = "sarhipov"
    type  = "SecureString"
  }
}
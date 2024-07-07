locals {
  github_access_credentials = jsondecode(data.aws_secretsmanager_secret_version.github_access.secret_string)
}
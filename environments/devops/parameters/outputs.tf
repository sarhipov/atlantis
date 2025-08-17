# output "github_secret_value" {
#   description = "Generated GitHub webhook secret (sensitive)"
#   value       = random_password.github_secret.result
#   sensitive   = true
# }
#
# output "github_secret_parameter_name" {
#   description = "AWS Parameter Store name for GitHub secret"
#   value       = aws_ssm_parameter.github_secret.name
# }
resource "random_password" "github_secret" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "parameters" {
  for_each = var.ssm_parameters

  name  = "/${each.key}"
  type  = each.value.type
  value = each.key == "atlantis/github_secret" && each.value.value == "" ? random_password.github_secret.result : each.value.value
}
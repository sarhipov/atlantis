locals {
  tags = {
    Environment     = var.environment
    Terraform       = "Managed"
    Terraform-state = "terraform_state_lock/terraform.tfstate"
  }
}
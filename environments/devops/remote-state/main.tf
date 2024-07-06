module "remote-state" {
  source = "../../../modules/remote-state"

  environment          = var.environment
  tf_state_bucket_name = var.tf_state_bucket_name
  dynamodb_table_name  = var.dynamodb_table_name
}
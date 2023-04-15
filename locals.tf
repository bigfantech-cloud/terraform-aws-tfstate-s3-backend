locals {
  environment = var.environment != "" ? "-${var.environment}" : ""
  aws_estate  = var.aws_estate != "" ? "-${var.aws_estate}" : ""

  bucket_name         = "${var.project_name}${local.aws_estate}${local.environment}-tfstate"
  dynamodb_table_name = "${var.project_name}${local.environment}-tfstate-lock"
}

output "tfstate_bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.tfstate_bucket.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.statelock.id
}

/*
Purpose: S3 bucket, dyanmoDB table creation for .tfstate remote backend

Variable Inputs:
project_name (project name);
environment (ex: test/dev/prod); (add this only if stage/env is applicable)
*/

resource "aws_s3_bucket" "tfstate-bucket" {
  bucket = local.bucket_name

  lifecycle {
    prevent_destroy = "true"
  }

  tags = {
    Environment  = var.environment == "" ? null : var.environment
    project_name = var.project_name
    ManagedBy    = "Terraform"

  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate-bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.tfstate-bucket.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.tfstate-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.tfstate-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "tfstate_bucket_policy" {
  bucket = aws_s3_bucket.tfstate-bucket.bucket

  policy = data.aws_iam_policy_document.tfstate_bucket_policy.json
}

data "aws_iam_policy_document" "tfstate_bucket_policy" {
  statement {
    sid = "DenyDeleteBucketAndObject"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    effect = "Deny"
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutLifecycleConfiguration"
    ]

    resources = [
      "${aws_s3_bucket.tfstate-bucket.arn}",
      "${aws_s3_bucket.tfstate-bucket.arn}/*",
    ]
  }
}

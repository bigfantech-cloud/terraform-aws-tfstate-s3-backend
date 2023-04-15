variable "project_name" {
  description = "project name"
  type        = string
}

variable "aws_estate" {
  description = <<EOF
  A name identifying the AWS account where the infrastructure is being setup.
  Used to name bucket unique when a project's environments are setup in different account
  EOF
  type        = string
  default     = ""
}

variable "environment" {
  description = "ex: test/dev/prod; (add *environment = test/dev/prod* in your .tfvars only if stage/env is applicable)"
  default     = ""
}

# Purpose:

Create S3 bucket, DyanmoDB table and setup .tfstate remote backend

> !! This module should be applied before setting up .tfstate remote backend on S3 !!

## Variable Inputs:

### Required

```
- project_name   (project name)
```

### Optional

```
- aws_estate:
    A name identifying the AWS account where the infrastructure is being setup.
    Used to name bucket unique when a project's environments are setup in different account

- environment (ex: dev/prod)
```

## Resources created:

1. S3 bucket.
2. DynamoDB table.

---

# Setting up .tfstate remote backend on S3.

1. Call the S3 bucket, DynamoDB table creating module from your tf code.
   (best: create a file named "remote-bucket.tf", and call from there)
2. Specifying Variable Inputs along the module call.

#### Example:

```
provider "aws" {
  region = "us-east-1"
}

module "remote_tfstate_bucket" {
  source      = "bigfantech-cloud/tfstate-s3-backend/aws"
  version     = "1.0.0"

  project_name   = "bigfantech"
  aws_estate     = "abc"
  environment    = "dev"
}
```

3. Apply: from terminal run following commands.

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

4. Place and keep the below code in your infra. tf code directory, and fill the data.
   (best: create a file `backend.tf`, and add the below code)

```
terraform {
backend "s3" {
bucket = "bucket_name"
key = "terrform.tfstate"
region = "aws_region"
dynamodb_table = "dynamodb_table_name"
encrypt = true
}
}
```

> Data to fill:

- bucket: name of the bucket created. (ex: bucket = "bigfantech-abc-dev-tfstate").

- key: file directory where the .tfstate need to be created in the bucket.
  ex: to save `.tfstate` in folder `dev`, fill the key as: `dev/terrform.tfstate` (including the file name).

- dynamodb_table: Name of the DynamoDB table created. (ex: "bigfantech-dev-tfstate-lock").
- region: Bucket region. (ex: us-east-1).

#### Example:

```
terraform {
backend "s3" {
bucket = "bigfantech-abc-dev-tfstate"
key = "terrform.tfstate"
region = "us-east-1"
dynamodb_table = "bigfantech-tfstate-lock"
encrypt = true
}
}
```

5. Initiating remote backend: Fron terminal by running the below command

```
terraform init
```

6. Applying remote backend.

```
terraform apply
```

!! You have successfully setup remote S3 backend for .tfstate !!

---

## OUTPUTS

```
tfstate_bucket_name:
  Name of the bucket to store .tfstate.

dynamodb_table_name:
  Name of the DynamoDB table created for .tfstate file lock.
```

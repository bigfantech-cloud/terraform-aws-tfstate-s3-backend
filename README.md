# BigFantech-Cloud

We automate your infrastructure.
You will have full control of your infrastructure, including Infrastructure as Code (IaC).

To hire, email: `bigfantech@yahoo.com`

# Purpose of this code

> Terraform module

- Create S3 bucket, DyanmoDB table, and setup .tfstate remote backend

## Required Providers

| Name                | Description |
| ------------------- | ----------- |
| aws (hashicorp/aws) | >= 4.47     |

## Variables

### Required Variables

| Name           | Description | Default |
| -------------- | ----------- | ------- |
| `project_name` |             |         |

### Optional Variables

| Name          | Description                                                                                                                                                         | Default |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `aws_estate`  | A name identifying the AWS account where the infrastructure is being setup. Used to name bucket unique when a project's environments are setup in different account | null    |
| `environment` |                                                                                                                                                                     |         |

# Setting up .tfstate remote backend on S3.

### Example config

1. Apply the module to create S3 bucket, and DynamoDB table

#### Example:

```

provider "aws" {
  region = "us-east-1"
}

module "remote_tfstate_bucket" {
  source = "bigfantech-cloud/tfstate-s3-backend/aws"
  version = "a.b.c" # find latest version from https://registry.terraform.io/modules/bigfantech-cloud/tfstate-s3-backend/aws/latest


  project_name = "bigfantech-cloud"
  aws_estate   = "abc"
  environment  = "dev"
}

```

```

terraform init

```

```

terraform plan

```

```

terraform apply

```

2. Place and keep the below code in your infra. tf code directory, and fill the data.
   (best: create a file `backend.tf`, and add the below code)

```

terraform {
  backend "s3" {
    bucket          = "bucket_name"         # Fill the bucket name
    key             = "terrform.tfstate"
    region          = "aws_region"          # Fill the bucket region
    dynamodb_table  = "dynamodb_table_name" # Fill the DynamoDB table name
    encrypt         = true
  }
}

```

#### Example:

```

terraform {
  backend "s3" {
    bucket          = "bigfantech-cloud-abc-dev-tfstate"
    key             = "terrform.tfstate"
    region          = "aws_region" # Fill the bucket region
    dynamodb_table  = "bigfantech-cloud-dev-tfstate-lock"
    encrypt         = true
  }
}

```

3. Initiating remote S3 backend: From terminal running the below command, and input `yes` when prompted.

```

terraform init

```

!! You have successfully setup remote S3 backend for .tfstate !!

---

### Outputs

| Name                  | Description                |
| --------------------- | -------------------------- |
| `tfstate_bucket_name` | Name of the bucket         |
| `dynamodb_table_name` | Name of the DynamoDB table |

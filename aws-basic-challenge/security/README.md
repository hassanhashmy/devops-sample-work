# Terraform AWS Config Setup
## This Terraform code deploys the following resources:

- AWS SNS Topic
- AWS S3 Bucket
- AWS Config Delivery Channel
- Aws Config Configuration Recorder
- AWS IAM Role
- AWS Config Rule

## Prerequisites
- An AWS account with appropriate permissions.
- Terraform

## Usage: 
1. Clone this code.
2. Navigate to the cloned code.
3. Modify variables.tf with your desired values.
4. Run terraform init to initialize the working directory.
5. Run terraform plan to see the changes that will be made.
6. Run terraform apply to create the AWS Config setup.

## Overview: 

 This terraform code is creating aws config and s3 bucket where we can send config logs. This code also creating appropriate policy and role require for aws config. In this example of code, we are creating a rule that targeting s3 and will send notification to sns topic when s3 bucket versioning will be enabled. We can create different rules in aws config e.g we will send notification each time lambda function triggers and for that code looks like:
 ```sh
source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.example.arn
  }
```
So we can add different rule according to our requirement.

List of AWS Config Managed Rules - https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

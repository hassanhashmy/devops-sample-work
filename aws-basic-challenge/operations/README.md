# Terraform AWS Session Manager 
## This Terraform code deploys the following resources:

- Session Manager Role
- Session Manager Policy
- Session Manager Profile
- Aws Security Group
- AWS Ec2 Instance
- IAM Users

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

 This terraform configuration has two files ssm.tf and iam.tf. In ssm.tf, We are creating session manager role which is helping to access private ec2 instance with ssm. We are setting permission so only only authoized user which we mention in var.username have access of connecting to that priavet ec2 via session managed.
 iam.tf have such configuration with which we can create iam user and storing its access and secret key in secret manager and giving user access to just specific resources like in this code we are just giving access to ec2 resources, so we can add resources in permission so user can have access on that service or resources.

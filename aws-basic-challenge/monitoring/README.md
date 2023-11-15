# CloudWatch Monitoring
## This Terraform code deploys the following resources:

- EC2 Instance
- IAM Instance Profile
- IAM Role
- IAM Role Policy
- CloudWatch Agent
- CloudWatch Dashboard
- CloudWatch Alarm
- SNS Topic
- SNS Subscription
- SNS Policy

 The EC2 instance is launched with a user data script that installs and configures the CloudWatch agent. The agent then collects CPU utilization metrics from the instance, which are used to create an alarm in CloudWatch. When the alarm threshold is breached, an email notification is sent via an SNS topic subscription.

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

 This terraform code is creating ec2 and installing cloudwatch agent in that ec2 then its creating dashboard in cloudwatch where we can see cpu utilization of ec2. Then we are setting cloudwatch metric alarm to monitor cpu utilization and if cpu value exceeds to 70%, it will send notification to sns topic and send email to email we provideded.

# Database Module

Terraform module which creates databse layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| aws_security_group | resource
| terraform-aws-modules/rds/aws | module
| aws_db_instance| resource

## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your enviorment, keep the value in lower case | Required
| db-username | Username of your master rds | Required
| db-password | Password of your master rds | Required
| db-engine | Engine version of your rds | Optional
| db-instance | Instance type of your rds | Required
| rdssubnetgroup |Name of your RDS SubnetGroup | Required
| masterdbidentifier | Name of your Master RDS Identifier Name | Optional
| rds-sg |Name of your RDS Security Group | Optional
| vpc_id | ID of the VPC | Required
| Privatesubnet1_id | The ID of any one of the private subnets in AWS VPC | Required
| Privatesubnet2_id | The ID of another one of the private subnets in AWS VPC | Required
| create | Set Variable to true or false for this module creation | Optional

## Outputs

| Name | Description | 
| ------ | ------ | 
| aws_db_instance_endpoint | Endpoint of master rds database.
| aws_db_instance_replica_endpoint | Endpoint of master replica rds database.


## Steps to Create Modules

This is the first command that should be run after cloning files from version control. The command is used to initialize a working directory containing Terraform configuration files.

```sh
terraform init
```

This command is used to rewrite Terraform configuration files to a canonical format and style.

```sh
terraform fmt --check
```

Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state.

```sh
terraform validate
```

This command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

```sh
terraform plan
```

Finally this command executes the actions proposed in a Terraform plan.

```sh
terraform apply
```

And a convenient way to destroy all remote objects managed by a particular Terraform configuration.

```sh
terraform destroy
```






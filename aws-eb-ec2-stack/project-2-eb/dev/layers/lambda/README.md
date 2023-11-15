# Lambda Module

Terraform module which creates lambda layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| terraform-aws-modules/lambda/aws | module


## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your enviorment, keep the value in lower case | Required
| lambda-runtime | Run time Engine version of your lambda function | Required
| lambda-edge-runtime | Run time Engine version of your lambda edge function | Required
| lambda-function-name | Name of your lambda function | Optional
| lambdaedge-function-name | Name of your lambda edge function | Optional
| lambda-function-filename | Filename of your lambda function | Required
| lambdaedge-function-filename | Filename of your lambda edge function | Required
| appbucket_id | S3 Appbucket ID | Required
| create | Set Variable to true or false for this module creation | Optional 

## Outputs

| Name | Description | 
| ------ | ------ | 
| lamda_function_arn | 	The ARN of the Lambda Function.
| lamda_function_edge_arn | The ARN of the Lambda Function Edge.



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






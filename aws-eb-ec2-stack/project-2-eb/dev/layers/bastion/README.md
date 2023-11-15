# Bastion Module

Terraform module which creates bastion layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| terraform-aws-modules/ec2-instance/aws | module
| terraform-aws-modules/security-group/aws | module
| aws_eip | resource


## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your enviorment keep the value in lower case | Required
| keypair | Name of your keypair in order to connect to bastion instances | Required
| instancetype | Instance type of your EC2 | Required
| ec2_instance_name | Name of your EC2 instance | Optional
| aws_ami |Fetch the latest ami image | Optional
| vpc_id | ID of the VPC | Required
| Publicsubnet_id | The ID of any one of the public subnets in AWS VPC | Required
| create | Set Variable to true or false for this module creation | Optional 

## Outputs

| Name | Description | 
| ------ | ------ | 
| bastion_host_eip_address | bastion host elastic ip address.


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





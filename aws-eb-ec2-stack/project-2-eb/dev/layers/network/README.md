# Network Module

Terraform module which creates network layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| terraform-aws-modules/vpc/aws | module


## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| EnvName | Name of your enviorment, keep the value in lower case | Required
| VPCBlock | VPC CIDR where you will deploy your Resources | Required
| SubnetPublic1 | Public Subnet a where you will deploy your public Resources | Required
| SubnetPublic2 | Public Subnet b where you will deploy your public Resources | Required
| SubnetPublic3 | Public Subnet c where you will deploy your public Resources | Required
| SubnetPrivate1 | Private Subnet a where you will deploy your private  resources | Required
| SubnetPrivate2 | Private Subnet b where you will deploy your private Resources | Required
| SubnetPrivate3 | Private Subnet c where you will deploy your private Resources | Required
| VPCZone1 | Zone name where you will deploy your subnets | Required
| VPCZone2 | Zone name where you will deploy your subnets | Required
| VPCZone3 | Zone name where you will deploy your subnets | Required
| create | Set Variable to true or false for this module creation | Optional

## Outputs

| Name | Description | 
| ------ | ------ | 
| vpc_id | Id of the vpc.
| PublicSubnet1_id | Id of the public subnet a.
| PublicSubnet2_id | Id of the public subnet b.
| PublicSubnet3_id | Id of the public subnet c.
| PrivateSubnet1_id | Id of the private subnet a.
| PrivateSubnet2_id | Id of the private subnet b. 
| PrivateSubnet3_id | Id of the private subnet c.

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






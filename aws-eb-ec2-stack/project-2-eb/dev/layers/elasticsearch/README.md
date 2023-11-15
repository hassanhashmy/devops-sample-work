# ElasticSearch Module

Terraform module which creates ElasticSearch layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| aws_security_group | resource
| aws_elasticsearch_domain | resource
| aws_iam_service_linked_role | resource


## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your enviorment, keep the value in lower case | Required
| es-version | Engine version of your Elastic Search cluster | Required
| es-domain | Name of your Elastic Search Domain Name | Optional
| es-instancetype | Instance type of your Elastic Search cluster | Required
| elasticsearch-sg | Name of your ElasticSearch Security Group| Optional
| vpc_id | ID of the VPC | Required
| Publicsubnet_id | The ID of any one of the public subnets in AWS VPC | Required
| create | Set Variable to true or false for this module creation | Optional

## Outputs

| Name | Description | 
| ------ | ------ | 
| elastic_search_endpoint | Domain-specific endpoint used to submit index, search, and data upload requests.

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






# ElasticBeanstalk Module

Terraform module which creates ElasticBeanstalk layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| aws_elastic_beanstalk_hosted_zone | data
| aws_route53_zone | data
| aws_elastic_beanstalk_application_version | resource
| aws_elastic_beanstalk_configuration_template | resource
| aws_elastic_beanstalk_environment | resource
| aws_route53_record | resource

## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your environment, keep the value in lower case |Required
| ebs-instancetype | Instance type of your ElasticBeanstalk |Required
| appbucket_id | ID of your S3 Appbucket |Required
| appbucket_web_id | ID of your Webpage object in S3 |Required
| ebs_app_name | Name of your EBS Application |Optional
| ebs-sloution-name | Name of your ElasticBeanstalk Application Solution Stack Name|Required
| ebs-writeapi-name |Name of your WriteApi EBS|Optional
| template-writeapi-name | Name of your WriteApi EBS Template|Optional
| env-writeapi-name |Name of your WriteApi EBS environment|Optional
| ebs-readapi-name | Name of your ReadApi EBS|Optional
| template-readapi-name| Name of your ReadApi EBS Template|Optional
| env-readapi-name | Name of your ReadApi EBS environment|Optional
| domain_name | Name of your Route53 zone assestbucket |Required
| create | Set Variable to true or false for this module creation |Optional

## Outputs

| Name | Description | 
| ------ | ------ | 
| aws_elastic_beanstalk_env_writeapi_id | ID of the Elastic Beanstalk Environment of writeapi.
| aws_elastic_beanstalk_env_writeapi_app | The Elastic Beanstalk Application specified for this environment writeapi.
| aws_elastic_beanstalk_env_writeapi_instances | Instances used by this Environment writeapi.
| aws_elastic_beanstalk_env_readapi_id | ID of the Elastic Beanstalk Environment of readapi.
| aws_elastic_beanstalk_env_readapi_app | The Elastic Beanstalk Application specified for this environment of readapi.
| aws_elastic_beanstalk_env_readapi_instances | Instances used by this Environment of readapi. 
| aws_route53_record_wrtieapi_RecordSet| The name of the record of writeapi.
| aws_route53_record_readapi_RecordSet| The name of the record recordapi.

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






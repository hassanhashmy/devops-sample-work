# Resources Module

Terraform module which creates resources layer.

## Resources

| Name | Type | 
| ------ | ------ | 
| aws_route53_zone | data
| aws_s3_object | resource
| terraform-aws-modules/s3-bucket/aws| module
| aws_s3_bucket_policy | resource
| aws_elasticache_cluster | resource
| aws_elasticache_replication_group | resource
| aws_elasticache_subnet_group | resource
| aws_security_group | resource
| terraform-aws-modules/sqs/aws | module
| aws_sqs_queue_policy | resource
| terraform-aws-modules/cloudfront/aws | module
| aws_route53_record | resource
| aws_elastic_beanstalk_application | resource
| aws_elastic_beanstalk_environment | resource
| aws_iam_role | resource
| aws_iam_role_policy | resource
| aws_codepipeline | resource
| aws_acm_certificate | resource
| aws_acm_certificate_validation | resource
| terraform-aws-modules/alb/aws | module


## Inputs

| Name | Description | Type
| ------ | ------ | ------ | 
| envname | Name of your enviorment, keep the value in lower case | Required
| redis-instancetype | Instance type of your Redis cache | Required
| redis-engine | Engine version of your Redis cache | Required
| ebs-instancetype | Instance type of your ElasticBeanstalk | Required
| appbucket_name | Name of your S3 appbucket name | Required
| assetsbucket_name | Name of your S3 appbucket name | Required
| rediscluster_name | Name of your RedisCluster | Optional
| redissubnetgroup | Name of your RedisSubnetGroup | Optional
| redis-sg | Name of your Redis Security Group | Optional
| sqsque | Name of your SQSQue file name | Required
| appbucket_cdn | Name of your Appbucket Clouddistribution CDN | Optional
| assestsbucket_cdn | Name of your Assests Clouddistribution CDN | Optional
| ebs-app | Name of your ElasticBeanstalk Application| Required
| ebs-app-env | Name of your ElasticBeanstalk Application Enviorment | Required
| ebs-sloution-name | Name of your ElasticBeanstalk Application Solution Stack Name | Required
| codepipeline | Name of your CodePipeline | Optional
| loadbalancer-sg | Name of your LoadBalancer security group | Optional
| loadbalancer | Name of your LoadBalancer | Optional
| domain_name | Name of your Domain | Required
| vpc_id | ID of the VPC | Required
| Publicsubnet1_id | The ID of any one of the public subnets in AWS VPC | Required
| Publicsubnet2_id | The ID of another one of the public subnets in AWS VPC | Required
| create | Set Variable to true or false for this module creation | Optional 

## Outputs

| Name | Description | 
| ------ | ------ | 
| appbucket_id | ID of the Appbucket S3
| appbucket_regional_domain_name | Appbucket hosted domain Name
| ebs-application-name | EBS application name
| appbucket_web_id | Appbucket webpage object ID
| sqsque_url |The URL of the SQS queue
| cdn_appbucket_id | The identifier for the distribution.
| cdn_appbucket_status | The current status of the distribution.
| cdn_appbucket_domain_name | The domain name corresponding to the distribution.
| cdn_assetsbucket_id | The identifier for the distribution.
| cdn_assetsbucket_status | The current status of the distribution.
| cdn_assetsbucket_domain_name | The domain name corresponding to the distribution.
| aws_elastic_beanstalk_env_app_id | ID of the Elastic Beanstalk Environment.
| aws_elastic_beanstalk_env_app_name | Name of the Elastic Beanstalk Environment.
| aws_elastic_beanstalk_env_app_instances | Instances used by this Environment.
| aws_acm_cert_appbucket_arn | The ARN of the certificate
| aws_acm_cert_appbucket_domainname | The domain name for which the certificate is issued
| aws_acm_cert_alb_arn | The ARN of the certificate
| aws_lb_loadbalancer_dns | The DNS name of the load balancer.


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






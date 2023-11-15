

output "aws_elastic_beanstalk_env_writeapi_id" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_writeapi[0].id, null)
}
output "aws_elastic_beanstalk_env_writeapi_app" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_writeapi[0].application, null)
}
output "aws_elastic_beanstalk_env_writeapi_instances" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_writeapi[0].instances, null)
}

output "aws_elastic_beanstalk_env_readapi_id" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_readapi[0].id, null)
}
output "aws_elastic_beanstalk_env_readapi_app" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_readapi[0].application, null)
}
output "aws_elastic_beanstalk_env_readapi_instances" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_env_readapi[0].instances, null)
}

output "aws_route53_record_wrtieapi_RecordSet" {
  value = try(aws_route53_record.ebs_wrtieapi_RecordSet[0].name, null)
}

output "aws_route53_record_readapi_RecordSet" {
  value = try(aws_route53_record.ebs_readapi_RecordSet[0].name, null)
}


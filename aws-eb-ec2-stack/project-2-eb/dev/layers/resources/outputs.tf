output "appbucket_id" {
  value = try(module.s3_bucket_app[0].s3_bucket_id, null)
}

output "appbucket_regional_domain_name" {
  value = try(module.s3_bucket_app[0].bucket_regional_domain_name, null)
}

output "appbucket_web_id" {
  value = try(aws_s3_object.appbucket_web[0].id, null)
}

output "ebs_application_name" {
  value = try("${var.EnvName}-${var.ebs_app}", null)
}
/*
output "elastic_cache_nodes" {
  value = try(aws_elasticache_cluster.rediscluster[0].cache_nodes, null)
}

output "elastic_cache_cluster_address" {
  value = try(aws_elasticache_cluster.rediscluster[0].cluster_address, null)
}

output "elastic_cache_configuration_endpoint" {
  value = try(aws_elasticache_cluster.rediscluster[0].configuration_endpoint, null)
}
*/
output "sqsque_url" {
  value = try(module.user_queue[0].url, null)
}

output "cdn_appbucket_id" {
  value = try(module.cdn_appbucket[0].cloudfront_distribution_id, null)
}

output "cdn_appbucket_status" {
  value = try(module.cdn_appbucket[0].cloudfront_distribution_status, null)
}

output "cdn_appbucket_domain_name" {
  value = try(module.cdn_appbucket[0].cloudfront_distribution_domain_name, null)
}

output "cdn_assetsbucket_id" {
  value = try(module.cdn_assestbucket[0].cloudfront_distribution_id, null)
}

output "cdn_assetsbucket_status" {
  value = try(module.cdn_assestbucket[0].cloudfront_distribution_status, null)
}

output "cdn_assetsbucket_domain_name" {
  value = try(module.cdn_assestbucket[0].cloudfront_distribution_domain_name, null)
}

output "aws_elastic_beanstalk_env_app_id" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_environment[0].id, null)
}
output "aws_elastic_beanstalk_env_app_name" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_environment[0].application, null)
}
output "aws_elastic_beanstalk_env_app_instances" {
  value = try(aws_elastic_beanstalk_environment.beanstalk_environment[0].instances, null)
}

output "aws_acm_cert_appbucket_arn" {
  value = try(aws_acm_certificate.cert_cdn[0].arn, null)
}
output "aws_acm_cert_appbucket_domainname" {
  value = try(aws_acm_certificate.cert_cdn[0].domain_name, null)
}

output "aws_acm_cert_alb_arn" {
  value = try(aws_acm_certificate.cert_alb[0].arn, null)
}

output "aws_lb_loadbalancer_dns" {
  value = try(module.alb[0].lb_dns_name, null)
}





output "lamda_function_arn" {
  value = try(module.lambda_function[0].arn, null)
}

output "lamda_function_edge_arn" {
  value = try(module.lambda_function[0].arn, null)
}
/*
output "lamda_edge_cdn_id" {
 value       = try(aws_cloudfront_distribution.lambda_distribution[0].id, null )
}

output "lamda_edge_cdn_status" {
 value       = try(aws_cloudfront_distribution.lambda_distribution[0].status, null )
}

output "lamda_edge_cdn_domain_name" {
 value       = try(aws_cloudfront_distribution.lambda_distribution[0].domain_name, null )
}
*/

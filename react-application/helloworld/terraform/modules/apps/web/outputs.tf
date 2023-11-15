output "bucket" {
  description = "Website S3 bucket name"
  value       = aws_s3_bucket.main.id
}

output "bucket_website_endpoint" {
  description = "S3 bucket website endpoint"
  value       = aws_s3_bucket.main.website_endpoint
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = try(aws_cloudfront_distribution.main[0].domain_name, null)
}

output "website_endpoint" {
  description = "CloudFront distribution domain name"
  value       = try(aws_cloudfront_distribution.main[0].domain_name, aws_s3_bucket.main.website_endpoint)
}

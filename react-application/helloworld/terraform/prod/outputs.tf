output "bucket" {
  description = "Website S3 bucket name"
  value       = module.app.bucket
}

output "bucket_website_endpoint" {
  description = "S3 bucket website endpoint"
  value       = module.app.bucket_website_endpoint
}

output "website_endpoint" {
  description = "Website endpoint"
  value       = module.app.website_endpoint
}

variable "name" {
  description = "The web application name or project name"
  type        = string
}

variable "environment" {
  description = "Environment name, such as, dev, test, qa, stage, prod"
  type        = string
}

variable "create_cloudfront_distribution" {
  description = "Specifies whether to create a CloudFront distribution or not. Default is false"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Specifies whether to destroy existing resources such as S3 bucket or not. Default is false"
  type        = bool
  default     = false
}

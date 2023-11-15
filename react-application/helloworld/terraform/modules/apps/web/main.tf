locals {
  bucket = "${var.name}-${var.environment}-${random_id.main.hex}"
  s3_origin = "s3Origin-${var.name}-${random_id.main.hex}"
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket

  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id

  acl = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.main,
    aws_s3_bucket_public_access_block.main,
  ]
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*",
        ]
      },
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.main
  ]
}

# CloudFront 
resource "aws_cloudfront_distribution" "main" {
  count = var.create_cloudfront_distribution ? 1 : 0
 
  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = local.s3_origin

    origin_access_control_id = aws_cloudfront_origin_access_control.main[0].id
  }

  enabled         = true
  is_ipv6_enabled = false
  comment         = "Simple web application CloudFront for ${var.name} ${var.environment}"

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   =  ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

# CloudFrontOriginAccessControl
resource "aws_cloudfront_origin_access_control" "main" {
  count = var.create_cloudfront_distribution ? 1 : 0

  name                              = "${var.name}-${var.environment}-default-${random_id.main.hex}"
  description                       = "Default Origin Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Random id for environment
resource "random_id" "main" {
  byte_length = 5
}

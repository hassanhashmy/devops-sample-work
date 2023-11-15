provider "aws" {
  region = var.aws_region
}

module "app" {
  source = "../modules/apps/web"

  name        = var.project
  environment = "prod"

  create_cloudfront_distribution = true
}

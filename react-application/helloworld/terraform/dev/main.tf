provider "aws" {
  region = var.aws_region
}

module "app" {
  source = "../modules/apps/web"

  name        = var.project
  environment = "dev"

  force_destroy = true
}

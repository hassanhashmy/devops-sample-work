provider "aws" {
  alias  = "lambda-edge"
  region = "us-east-1"
}


module "lambda_function" {
  source         = "terraform-aws-modules/lambda/aws"
  version        = "3.2.0"
  count          = var.create ? 1 : 0
  function_name  = var.lambda_function_name
  handler        = "${var.lambda_function_name}.lambda_handler"
  runtime        = var.lambda_runtime
  create_package = false
  s3_existing_package = {
    bucket = var.appbucket_id
    key    = var.lambda_function_filename
  }


  tags = {
    Name = "${var.EnvName}-lambda-function"
  }
}

module "lambda_at_edge" {
  source         = "terraform-aws-modules/lambda/aws"
  version        = "3.2.0"
  count          = var.create ? 1 : 0
  lambda_at_edge = true

  function_name = var.lambdaedge_function_name
  handler       = "${var.lambdaedge_function_name}.lambda_handler"
  runtime       = var.lambda_edge_runtime

  create_package          = false
  local_existing_package  = var.lambdaedge_function_filename
  ignore_source_code_hash = true

  providers = {
    aws = aws.lambda-edge
  }

  tags = {
    Name = "${var.EnvName}-lambda-at-edge"
  }
}

variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.6"
  description = "Run time Engine version of your lambda function"
}

variable "lambda_edge_runtime" {
  type        = string
  default     = "python3.7"
  description = "Run time Engine version of your lambda edge function"
}

variable "lambda_function_name" {
  type        = string
  default     = "hello-lambda"
  description = "Name of your lambda function"
}

variable "lambdaedge_function_name" {
  type        = string
  default     = "hello-lambda-edge"
  description = "Name of your lambda edge function"
}

variable "lambda_function_filename" {
  type        = string
  default     = "hello_lambda.zip"
  description = "Filename of your lambda function"
}

variable "lambdaedge_function_filename" {
  type        = string
  default     = "hello_lambda.zip"
  description = "Filename of your lambda edge function"
}

variable "appbucket_id" {
  type        = string
  description = "S3 Appbucket ID"
}

variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}


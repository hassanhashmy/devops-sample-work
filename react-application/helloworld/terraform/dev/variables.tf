variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name, such as, dev, test, qa, stage, prod"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

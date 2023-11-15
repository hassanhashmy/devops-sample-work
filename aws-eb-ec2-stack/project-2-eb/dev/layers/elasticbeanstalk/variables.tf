variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}

variable "ebs_instancetype" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of your ElasticBeanstalk"
}

variable "appbucket_web_id" {
  description = "ID of your Appbucket Webpage"
  type        = string
}

variable "appbucket_id" {
  description = "ID of your S3 Appbucket"
  type        = string
}

variable "ebs_app_name" {
  description = "Name of your EBS Application"
  type        = string
}

variable "ebs_sloution_name" {
  type        = string
  default     = "64bit Amazon Linux 2018.03 v2.9.28 running PHP 7.2"
  description = "Name of your ElasticBeanstalk Application Solution Stack Name"
}

variable "ebs_writeapi_name" {
  type        = string
  default     = "ebs-writeapi"
  description = "Name of your WriteApi EBS"
}

variable "template_writeapi_name" {
  type        = string
  default     = "writeapi-template"
  description = "Name of your WriteApi EBS Template"
}

variable "env_writeapi_name" {
  type        = string
  default     = "ebs-env-writeapi"
  description = "Name of your WriteApi EBS Template"
}

variable "ebs_readapi_name" {
  type        = string
  default     = "ebs-readapi"
  description = "Name of your ReadApi EBS"
}

variable "template_readapi_name" {
  type        = string
  default     = "readapi-template"
  description = "Name of your ReadApi EBS Template"
}

variable "env_readapi_name" {
  type        = string
  default     = "ebs-env-readapi"
  description = "Name of your ReadApi EBS Template"
}

variable "domain_name" {
  type        = string
  default     = "hybyteslabs.com"
  description = "Name of your Route53 zone assestbucket"
}

variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}





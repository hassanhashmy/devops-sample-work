variable "awsregion" {
  description = "Name of aws region"
  default     = "us-east-2"

}

variable "snstopic_name" {
  description = "Name of sns topic name"
  default     = "example"

}

variable "bucket_name" {
  description = "Name of s3 bucket"
  default     = "tetndlksnc"

}

variable "config_delivery_channel_name" {
  description = "Name of aws config delivery channel name"
  default     = "example"

}

variable "config_recorder_name" {
  description = "Name of aws config recorder name"
  default     = "example"
}

variable "role-name" {
  description = "Name of role name"
  default     = "example"

}

variable "policy-name" {
  description = "Name of policy name"
  default     = "example"

}

variable "rule_name" {
  description = "Name of rule name"
  default     = "example"

}

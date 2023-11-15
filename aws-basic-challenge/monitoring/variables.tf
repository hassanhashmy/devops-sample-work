variable "awsregion" {
  description = "Name of aws region name"
  default     = "us-east-2"
}

variable "ami" {
  description = "Value of ami will be used for ec2"
  default     = ""
}

variable "instance_name" {
  description = "Namw of instance name"
  default     = "example"
}

variable "instance_type" {
  description = "Value of instance size of ec2"
  default     = "t2.micro"
}

variable "instance-profile-name" {
  description = "Name of ec2 profile name"
  default     = "EC2"
}

variable "policy-name" {
  description = "Name of policy name"
  default     = "ec2"
}

variable "sns_topic_name" {
  description = "Name of sns topic"
  default     = "example"

}
variable "role" {
  description = "Name of role name"
  default     = "ec2"
}

variable "trail_name" {
  description = "Name of trail name"
  default     = "example"
}

variable "s3-bucket-name" {
  description = "Name of s3 bucket name"
  default     = "sdsasdsda"

}
variable "email" {
  description = "Email to be used in sns"
  default     = "abc@yourdomain.com"

}

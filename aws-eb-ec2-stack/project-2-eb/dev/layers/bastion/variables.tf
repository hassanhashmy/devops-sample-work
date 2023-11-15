variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of the enviorment, keep the value in lower case"
}

variable "keypair" {
  type        = string
  default     = "bastion-keypair"
  description = "Name of the keypair, in order to connect to bastion instances"
}

variable "instancetype" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of the EC2"
}

variable "ec2_instance_name" {
  type        = string
  default     = "bastionhost"
  description = "Name of the EC2 instance"
}

data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


variable "vpc_id" {
  description = "ID of the VPC"
  type        = string

}

variable "Publicsubnet_id" {
  description = "ID of the Publicsubnet1"
  type        = string
}

variable "ec2_sg" {
  type        = string
  default     = "Bastionhost-sg"
  description = "Name of the EC2 Security Group"
}

variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}

variable "cidr_blocks_sg" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}



variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}

variable "db_username" {
  type        = string
  default     = "postgres"
  description = "Username of your master rds"
}

variable "db_password" {
  type        = string
  default     = "postgres"
  description = "Password of your master rds"
}

variable "db_engine" {
  type        = string
  default     = "postgres"
  description = "Engine version of your rds"
}

variable "db_instance" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance type of your rds"
}

variable "rdssubnetgroup" {
  type        = string
  default     = "dbsubnetgroup"
  description = "Name of your RDS SubnetGroup"
}

variable "masterdbidentifier" {
  type        = string
  default     = "db-master"
  description = "Name of your Master RDS Identifier Name"
}
variable "rds_sg" {
  type        = string
  default     = "rdssecuritygroup"
  description = "Name of your RDS Security Group"
}

variable "vpc_id" {
  description = "ID of your VPC"
  type        = string
}


variable "Privatesubnets_ids" {
  description = "ID of your two Privatesubnets"
  type        = list(string)
}


variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}

variable "VPCZone1" {
  type        = string
  default     = "eu-west-2a"
  description = "Zone name where you will deploy your subnets"
}
variable "VPCZone2" {
  type        = string
  default     = "eu-west-2b"
  description = "Zone name where you will deploy your subnets"
}

variable "allocated_storage" {
  type        = number
  default     = 5
  description = "Allocated Storage for your RDS"
}



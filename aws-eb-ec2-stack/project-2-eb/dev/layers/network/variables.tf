variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}
variable "VPCBlock" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR where you will deploy your Resources"
}
variable "SubnetPublic1" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Public Subnet a where you will deploy your public Resources"
}
variable "SubnetPublic2" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Public Subnet b where you will deploy your public Resources"
}
variable "SubnetPublic3" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Public Subnet c where you will deploy your public Resources"
}
variable "SubnetPrivate1" {
  type        = string
  default     = "10.0.3.0/24"
  description = "Private Subnet a where you will deploy your private Resources"
}
variable "SubnetPrivate2" {
  type        = string
  default     = "10.0.4.0/24"
  description = "Private Subnet b where you will deploy your private Resources"
}
variable "SubnetPrivate3" {
  type        = string
  default     = "10.0.5.0/24"
  description = "Private Subnet c where you will deploy your private Resources"
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
variable "VPCZone3" {
  type        = string
  default     = "eu-west-2c"
  description = "Zone name where you will deploy your subnets"
}
variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for this module creation"
}



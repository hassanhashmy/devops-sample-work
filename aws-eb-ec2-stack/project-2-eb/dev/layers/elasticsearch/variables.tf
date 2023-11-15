variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}

variable "es_version" {
  type        = string
  default     = "6.8"
  description = "Engine version of your Elastic Search cluster"
}

variable "es_domain" {
  type        = string
  default     = "elasticsearch"
  description = "Name of your Elastic Search Domain Name"
}

variable "es_instancetype" {
  type        = string
  default     = "t3.small.elasticsearch"
  description = "Instance type of your Elastic Search cluster"
}

variable "vpc_id" {
  description = "ID of your VPC"
  type        = string
}

variable "Publicsubnets_ids" {
  description = "ID of your two Publicsubnets"
  type        = list(string)
}

variable "Privatesubnets_ids" {
  description = "ID of your two Publicsubnets"
  type        = list(string)
}

variable "elasticsearch_sg" {
  type        = string
  default     = "elasticsearch-sg"
  description = "Name of your ElasticSearch Security Group"
}

variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}


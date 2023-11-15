variable "EnvName" {
  type        = string
  default     = "development"
  description = "Name of your enviorment, keep the value in lower case"
}
variable "redis_instancetype" {
  type        = string
  default     = "cache.t2.micro"
  description = "Instance type of your Redis cache"
}

variable "redis_engine" {
  type        = string
  default     = "3.2.10"
  description = "Engine version of your Redis cache"
}

variable "ebs_instancetype" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of your ElasticBeanstalk"
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

variable "appbucket_name" {
  type        = string
  default     = "appbucket-development"
  description = "Name of your S3 appbucket name"
}

variable "assetsbucket_name" {
  type        = string
  default     = "assetsbucket-development"
  description = "Name of your S3 appbucket name"
}

variable "rediscluster_name" {
  type        = string
  default     = "rediscluster"
  description = "Name of your RedisCluster"
}

variable "redissubnetgroup" {
  type        = string
  default     = "redissubnetgroup"
  description = "Name of your RedisSubnetGroup"
}

variable "redis_sg" {
  type        = string
  default     = "redissecuritygroup"
  description = "Name of your Redis Security Group"
}

variable "sqsque" {
  type        = string
  default     = "sqsque"
  description = "Name of your SQSQue file name"
}

variable "appbucket_cdn" {
  type        = string
  default     = "appbucket-cdn"
  description = "Name of your Appbucket Clouddistribution CDN"
}

variable "assestsbucket_cdn" {
  type        = string
  default     = "assestsbucket-cdn"
  description = "Name of your Assests Clouddistribution CDN"
}


variable "ebs_app" {
  type        = string
  default     = "ebs-app"
  description = "Name of your ElasticBeanstalk Application"
}

variable "ebs_app_env" {
  type        = string
  default     = "ebs-app-env"
  description = "Name of your ElasticBeanstalk Application Enviorment"
}

variable "ebs_sloution_name" {
  type        = string
  default     = "64bit Amazon Linux 2018.03 v2.9.28 running PHP 7.2"
  description = "Name of your ElasticBeanstalk Application Solution Stack Name"
}

variable "codepipeline" {
  type        = string
  default     = "codepipeline"
  description = "Name of your CodePipeline"
}

variable "loadbalancer_sg" {
  type        = string
  default     = "loadbalancer-sg"
  description = "Name of your LoadBalancer security group"
}

variable "loadbalancer" {
  type        = string
  default     = "loadbalancer"
  description = "Name of your LoadBalancer"
}

variable "domain_name" {
  type        = string
  default     = "hybyteslabs.com"
  description = "Name of your Domain"
}
variable "create" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for module creation"
}









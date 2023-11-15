variable "create_network" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for network module creation"
}
variable "create_bastion" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for bastion module creation"
}
variable "create_database" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for database module creation"
}
variable "create_elasticbeanstalk" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for elasticbeanstalk module creation"
}
variable "create_elasticsearch" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for elasticsearch module creation"
}
variable "create_lambda" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for lambda module creation"
}
variable "create_resources" {
  type        = bool
  default     = true
  description = "Set Variable to true or false for resources module creation"
}

variable "EnvName" {
  type        = string
  default     = "dev"
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
variable "ec2_keypair" {
  type        = string
  default     = "bastion-keypair"
  description = "Name of the keypair, in order to connect to bastion instances"
}

variable "ec2_instancetype" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of the EC2"
}

variable "ec2_instance_name" {
  type        = string
  default     = "bastionhost"
  description = "Name of the EC2 instance"
}

variable "ec2_sg_name" {
  type        = string
  default     = "Bastionhost-sg"
  description = "Name of the EC2 Security Group"
}

variable "ec2_cidr_blocks_sg" {
  type    = list(string)
  default = ["0.0.0.0/0"]
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
variable "allocated_storage" {
  type        = number
  default     = 5
  description = "Allocated Storage for your RDS"
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
variable "elasticsearch_sg" {
  type        = string
  default     = "elasticsearch-sg"
  description = "Name of your ElasticSearch Security Group"
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

variable "ebs_instancetype" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of your ElasticBeanstalk"
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
  default     = "hassanhashmy.com"
  description = "Name of your Route53 zone assestbucket"
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





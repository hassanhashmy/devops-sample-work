terraform {
  required_providers {
    aws = {
      version = "4.10.0"
    }
  }

  required_version = "1.1.7"
}
provider "aws" {
  region = "eu-west-2"
}


module "network" {
  source         = "./layers/network"
  create         = var.create_network
  EnvName        = var.EnvName
  VPCBlock       = var.VPCBlock
  SubnetPublic1  = var.SubnetPublic1
  SubnetPublic2  = var.SubnetPublic2
  SubnetPublic3  = var.SubnetPublic3
  SubnetPrivate1 = var.SubnetPrivate1
  SubnetPrivate2 = var.SubnetPrivate2
  SubnetPrivate3 = var.SubnetPrivate3
  VPCZone1       = var.VPCZone1
  VPCZone2       = var.VPCZone2
  VPCZone3       = var.VPCZone3
}


module "bastion" {
  source            = "./layers/bastion"
  create            = var.create_bastion
  vpc_id            = module.network.vpc_id
  Publicsubnet_id   = module.network.PublicSubnet1_id
  EnvName           = var.EnvName
  ec2_sg            = var.ec2_sg_name
  cidr_blocks_sg    = var.ec2_cidr_blocks_sg
  ec2_instance_name = var.ec2_instance_name
  keypair           = var.ec2_keypair
  instancetype      = var.ec2_instancetype
}


module "resources" {
  source             = "./layers/resources"
  create             = var.create_resources
  vpc_id             = module.network.vpc_id
  Publicsubnets_ids  = [module.network.PublicSubnet1_id, module.network.PublicSubnet2_id]
  Privatesubnets_ids = [module.network.PrivateSubnet1_id, module.network.PrivateSubnet2_id]
  EnvName            = var.EnvName
  redis_engine       = var.redis_engine
  redis_instancetype = var.redis_instancetype
  redis_sg           = var.redis_sg
  rediscluster_name  = var.rediscluster_name
  redissubnetgroup   = var.redissubnetgroup
  ebs_app            = var.ebs_app
  ebs_app_env        = var.ebs_app_env
  ebs_instancetype   = var.ebs_instancetype
  appbucket_cdn      = var.appbucket_cdn
  appbucket_name     = var.appbucket_name
  assestsbucket_cdn  = var.assestsbucket_cdn
  assetsbucket_name  = var.assetsbucket_name
  sqsque             = var.sqsque
  ebs_sloution_name  = var.ebs_sloution_name
  codepipeline       = var.codepipeline
  loadbalancer       = var.loadbalancer
  loadbalancer_sg    = var.loadbalancer_sg

}

module "database" {
  source             = "./layers/database"
  create             = var.create_database
  vpc_id             = module.network.vpc_id
  Privatesubnets_ids = [module.network.PrivateSubnet1_id, module.network.PrivateSubnet2_id]
  EnvName            = var.EnvName
  db_engine          = var.db_engine
  db_instance        = var.db_instance
  db_password        = var.db_password
  db_username        = var.db_username
  allocated_storage  = var.allocated_storage
  masterdbidentifier = var.masterdbidentifier
  rds_sg             = var.rds_sg
  rdssubnetgroup     = var.rdssubnetgroup
}

module "elasticsearch" {
  source             = "./layers/elasticsearch"
  create             = var.create_elasticsearch
  vpc_id             = module.network.vpc_id
  Publicsubnets_ids  = [module.network.PublicSubnet1_id, module.network.PublicSubnet2_id]
  Privatesubnets_ids = [module.network.PrivateSubnet2_id, module.network.PrivateSubnet3_id]
  EnvName            = var.EnvName
  es_domain          = var.es_domain
  es_instancetype    = var.es_instancetype
  es_version         = var.es_version
  elasticsearch_sg   = var.elasticsearch_sg
}

module "lambda" {
  create                       = var.create_lambda
  source                       = "./layers/lambda"
  appbucket_id                 = module.resources.appbucket_id
  EnvName                      = var.EnvName
  lambda_edge_runtime          = var.lambda_edge_runtime
  lambda_function_filename     = var.lambda_function_filename
  lambda_function_name         = var.lambda_function_name
  lambda_runtime               = var.lambda_runtime
  lambdaedge_function_filename = var.lambdaedge_function_filename
  lambdaedge_function_name     = var.lambdaedge_function_name
}

module "elasticbeanstalk" {
  create                 = var.create_elasticbeanstalk
  source                 = "./layers/elasticbeanstalk"
  appbucket_id           = module.resources.appbucket_id
  appbucket_web_id       = module.resources.appbucket_web_id
  ebs_app_name           = module.resources.ebs_application_name
  EnvName                = var.EnvName
  ebs_instancetype       = var.ebs_instancetype
  ebs_readapi_name       = var.ebs_readapi_name
  ebs_sloution_name      = var.ebs_sloution_name
  ebs_writeapi_name      = var.ebs_writeapi_name
  template_readapi_name  = var.template_readapi_name
  template_writeapi_name = var.template_writeapi_name
  env_readapi_name       = var.env_readapi_name
  env_writeapi_name      = var.env_writeapi_name
  domain_name            = var.domain_name
  depends_on             = [module.resources]
}

########## Exporting external module ######################
/*
module "external_elasticserch_module"{
  source  = "github.com/infrablocks/terraform-aws-bastion"
  

  vpc_id = module.network.vpc_id
  subnet_ids = [module.network.PublicSubnet1_id,module.network.PublicSubnet2_id]
  
  deployment_identifier = var.EnvName
  ssh_public_key_path = "id_rsa.pem"
  component = "bastion"
  allowed_cidrs = ["0.0.0.0/0"]
  egress_cidrs = ["0.0.0.0/0"]
  ami = data.aws_ami.instance_ami.id
  instance_type = var.ec2_instancetype
    
  minimum_instances = 1
  maximum_instances = 2
  desired_instances = 1

}
*/

########## Importing resource ######################
# kindly run the following command "terraform import aws_instance.ec2-instance "ID of your ec2 instance" 
/*
resource "aws_instance" "ec2-instance" {
 security_groups = [var.ec2_sg_name]
}
*/

#########Saving terraform state################## 

/*
resource "aws_s3_bucket" "b" {
  bucket = "terraform-state-record-up-running"
  force_destroy = true
  tags = {
    Environment = var.EnvName
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-record-up-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-record-up-running"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-record-up-running-locks"
    encrypt        = true
  }
}
*/



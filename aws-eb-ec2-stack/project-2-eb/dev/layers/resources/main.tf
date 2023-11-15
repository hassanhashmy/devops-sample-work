provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_route53_zone" "selected" {
  count        = var.create ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

resource "aws_s3_object" "appbucket_lamda" {
  count  = var.create ? 1 : 0
  bucket = module.s3_bucket_app[0].s3_bucket_id
  key    = "hello_lambda.zip"
  source = "hello_lambda.zip"
}

resource "aws_s3_object" "appbucket_web" {
  count  = var.create ? 1 : 0
  bucket = module.s3_bucket_app[0].s3_bucket_id
  key    = "index.zip"
  source = "index.zip"
}

module "s3_bucket_app" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.0"
  count   = var.create ? 1 : 0
  bucket  = var.appbucket_name
  tags = {
    Name = "${var.EnvName}-${var.appbucket_name}"
  }
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  count  = var.create ? 1 : 0
  bucket = module.s3_bucket_app[0].s3_bucket_id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.appbucket_name}/*"
    
    }
  ]
}
POLICY
}

module "s3_bucket_assest" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.0"
  count   = var.create ? 1 : 0
  bucket  = var.assetsbucket_name
  tags = {
    Name = "${var.EnvName}-${var.assetsbucket_name}"
  }
}
resource "aws_s3_bucket_policy" "asset_bucket_policy" {
  count  = var.create ? 1 : 0
  bucket = module.s3_bucket_assest[0].s3_bucket_id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.assetsbucket_name}/*"
    
    }
  ]
}
POLICY
}

module "user_queue" {
  source                    = "terraform-aws-modules/sqs/aws"
  version                   = "3.3.0"
  count                     = var.create ? 1 : 0
  name                      = "${var.EnvName}-${var.sqsque}.fifo"
  fifo_queue                = true
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Name = "${var.EnvName}-${var.sqsque}"
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  count     = var.create ? 1 : 0
  queue_url = module.user_queue[0].sqs_queue_id

  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Principal": {},
			"Effect": "Allow",
			"Action": [],
			"Resource": []
		}
	]
}
POLICY
}


module "cdn_appbucket" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  version                       = "2.9.3"
  enabled                       = true
  count                         = var.create ? 1 : 0
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = module.s3_bucket_app[0].s3_bucket_id
  }
  origin = {
    s3_one = {
      domain_name = module.s3_bucket_app[0].s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  viewer_certificate = {
    acm_certificate_arn = "${aws_acm_certificate.cert_cdn[0].arn}"
    ssl_support_method  = "sni-only"
  }
}

module "cdn_assestbucket" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  version                       = "2.9.3"
  enabled                       = true
  count                         = var.create ? 1 : 0
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = module.s3_bucket_assest[0].s3_bucket_id
  }
  origin = {
    s3_one = {
      domain_name = module.s3_bucket_assest[0].s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }
}

resource "aws_route53_record" "recordset_appbucket" {
  count   = var.create ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = "www.appbucket.${var.domain_name}"
  type    = "CNAME"

  alias {
    name                   = module.cdn_appbucket[0].cloudfront_distribution_domain_name
    zone_id                = module.cdn_appbucket[0].cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "recordset_assestbucket" {
  count   = var.create ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = "www.assestbucket.${var.domain_name}"
  type    = "CNAME"

  alias {
    name                   = module.cdn_assestbucket[0].cloudfront_distribution_domain_name
    zone_id                = module.cdn_assestbucket[0].cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert_cdn" {
  count                     = var.create ? 1 : 0
  domain_name               = var.domain_name
  validation_method         = "DNS"
  provider                  = aws.virginia
  subject_alternative_names = ["*.${var.domain_name}"]
  tags = {
    Name = "${var.EnvName}-${var.domain_name}-cdn"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  depends_on = [aws_acm_certificate.cert_cdn]
  zone_id    = data.aws_route53_zone.selected[0].zone_id
  for_each = var.create == true ? {
    for dvo in aws_acm_certificate.cert_cdn[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "certificate_validation_cdn" {
  count                   = var.create ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert_cdn[0].arn
  provider                = aws.virginia
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}


resource "aws_elastic_beanstalk_application" "ebs_app" {
  count = var.create ? 1 : 0
  name  = "${var.EnvName}-${var.ebs_app}"

  appversion_lifecycle {
    service_role = aws_iam_role.beanstalk_service[0].arn
    max_count    = 128
  }
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  count               = var.create ? 1 : 0
  name                = "${var.EnvName}-${var.ebs_app_env}"
  application         = aws_elastic_beanstalk_application.ebs_app[0].name
  solution_stack_name = var.ebs_sloution_name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.ebs_instancetype
  }
}

resource "aws_iam_role" "beanstalk_service" {
  count              = var.create ? 1 : 0
  name               = "beanstalk-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "codepipeline_role" {
  count = var.create ? 1 : 0
  name  = "codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "codepipeline_policy" {
  count  = var.create ? 1 : 0
  name   = "codepipeline-policy"
  role   = aws_iam_role.codepipeline_role[0].id
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::codepipeline*",
                "arn:aws:s3:::elasticbeanstalk*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:CreateApplicationVersion",
                "elasticbeanstalk:DescribeApplicationVersions",
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:DescribeEvents",
                "elasticbeanstalk:UpdateEnvironment"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::elasticbeanstalk*",
            "Effect": "Allow"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  count    = var.create ? 1 : 0
  name     = "${var.EnvName}-${var.codepipeline}"
  role_arn = aws_iam_role.codepipeline_role[0].arn

  artifact_store {
    location = var.appbucket_name
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        S3Bucket    = module.s3_bucket_app[0].s3_bucket_bucket_domain_name
        S3ObjectKey = "index.html"
      }

    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        ApplicationName = "${aws_elastic_beanstalk_application.ebs_app[0].name}"
        EnvironmentName = "${aws_elastic_beanstalk_environment.beanstalk_environment[0].name}"
      }

    }
  }


}


resource "aws_security_group" "loadbalancer_sg" {
  count  = var.create ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.EnvName}-${var.loadbalancer_sg}"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.EnvName}-${var.loadbalancer_sg}"
  }
}

resource "aws_acm_certificate" "cert_alb" {
  count                     = var.create ? 1 : 0
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
  tags = {
    Name = "${var.EnvName}-${var.domain_name}-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation_alb" {
  depends_on = [aws_acm_certificate.cert_alb]
  zone_id    = data.aws_route53_zone.selected[0].zone_id
  for_each = var.create == true ? {
    for dvo in aws_acm_certificate.cert_alb[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "certificate_validation_alb" {
  count                   = var.create ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert_alb[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation_alb : record.fqdn]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"
  count   = var.create ? 1 : 0
  name    = "${var.EnvName}-${var.loadbalancer}"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.Publicsubnets_ids
  security_groups = ["${aws_security_group.loadbalancer_sg[0].id}"]


  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.cert_alb[0].arn
    }
  ]

  tags = {
    Name = "${var.EnvName}-${var.loadbalancer}"
  }
}

resource "aws_elasticache_subnet_group" "redissubnetgroup" {
  count      = var.create ? 1 : 0
  name       = "${var.EnvName}-${var.redissubnetgroup}"
  subnet_ids = var.Privatesubnets_ids
}
resource "aws_security_group" "redis_sg" {
  count  = var.create ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.EnvName}-${var.redis_sg}"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.EnvName}-${var.redis_sg}"
  }
}

resource "aws_elasticache_cluster" "rediscluster" {
  count                = var.create ? 1 : 0
  cluster_id           = "${var.EnvName}-${var.rediscluster_name}"
  replication_group_id = aws_elasticache_replication_group.redis_replication_group[0].id
  tags = {
    Name = "${var.EnvName}-${var.rediscluster_name}"
  }
}

resource "aws_elasticache_replication_group" "redis_replication_group" {
  count                = var.create ? 1 : 0
  replication_group_id = "${var.EnvName}-${var.rediscluster_name}"
  description          = "redis replication group"
  node_type            = var.redis_instancetype
  num_cache_clusters   = 2
  port                 = 6379
  engine_version       = var.redis_engine
  subnet_group_name    = aws_elasticache_subnet_group.redissubnetgroup[0].name
  security_group_ids   = [aws_security_group.redis_sg[0].id]

}




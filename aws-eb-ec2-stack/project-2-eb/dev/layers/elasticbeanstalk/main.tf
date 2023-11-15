data "aws_elastic_beanstalk_hosted_zone" "current" {
  count = var.create ? 1 : 0
}

data "aws_route53_zone" "selected" {
  count        = var.create ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

resource "aws_elastic_beanstalk_application_version" "ebs_writeapi_version" {
  count       = var.create ? 1 : 0
  name        = "${var.EnvName}-${var.ebs_writeapi_name}"
  application = var.ebs_app_name
  bucket      = var.appbucket_id
  key         = var.appbucket_web_id
}

resource "aws_elastic_beanstalk_configuration_template" "writeapi_template" {
  count          = var.create ? 1 : 0
  name           = var.template_writeapi_name
  application    = var.ebs_app_name
  environment_id = aws_elastic_beanstalk_environment.beanstalk_env_writeapi[0].id
}


resource "aws_elastic_beanstalk_environment" "beanstalk_env_writeapi" {
  count               = var.create ? 1 : 0
  name                = "${var.EnvName}-${var.env_writeapi_name}"
  application         = var.ebs_app_name
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
  depends_on = [
    aws_elastic_beanstalk_application_version.ebs_writeapi_version
  ]
}

resource "aws_route53_record" "ebs_wrtieapi_RecordSet" {
  count   = var.create ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = aws_elastic_beanstalk_configuration_template.writeapi_template[0].name
  type    = "CNAME"

  alias {
    name                   = aws_elastic_beanstalk_environment.beanstalk_env_writeapi[0].cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current[0].id
    evaluate_target_health = false
  }
}


resource "aws_elastic_beanstalk_application_version" "ebs_readapi_version" {
  count       = var.create ? 1 : 0
  name        = "${var.EnvName}-${var.ebs_readapi_name}"
  application = var.ebs_app_name
  bucket      = var.appbucket_id
  key         = var.appbucket_web_id
}

resource "aws_elastic_beanstalk_configuration_template" "readapi_template" {
  count          = var.create ? 1 : 0
  name           = var.template_readapi_name
  application    = var.ebs_app_name
  environment_id = aws_elastic_beanstalk_environment.beanstalk_env_readapi[0].id
}

resource "aws_elastic_beanstalk_environment" "beanstalk_env_readapi" {
  count               = var.create ? 1 : 0
  name                = "${var.EnvName}-${var.env_readapi_name}"
  application         = var.ebs_app_name
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

resource "aws_route53_record" "ebs_readapi_RecordSet" {
  count   = var.create ? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = aws_elastic_beanstalk_configuration_template.readapi_template[0].name
  type    = "CNAME"

  alias {
    name                   = aws_elastic_beanstalk_environment.beanstalk_env_readapi[0].cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current[0].id
    evaluate_target_health = false
  }
}

provider "aws" {
  region = var.awsregion

}

locals {
  userdata = templatefile("user_data.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })

  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}
data "aws_caller_identity" "current" {}


resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data            = local.userdata
  tags = {
    Name = var.instance_name
  }
}

resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("cw_agent_config.json")
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.instance-profile-name}-Profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(local.role_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = element(local.role_policy_arns, count.index)
}

resource "aws_iam_role_policy" "this" {
  name = "${var.policy-name}-Policy"
  role = aws_iam_role.this.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "this" {
  name = "${var.role}-Role"
  path = "/"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow"
        }
      ]
    }
  )
}

resource "aws_cloudwatch_dashboard" "EC2_Dashboard" {
  dashboard_name = "EC2-Dashboard"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "width": 24,
            "height": 15,
            "x": 0,
            "y": 0,
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::EC2::Instance",
                        "InstanceId": "${aws_instance.this.id}",
                        "stat": "Maximum"
                    }
                ],
                "aggregateBy": {
                    "key": "InstanceType",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "State",
                        "value": "running"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "rowsPerPage": 8,
                    "widgetsPerRow": 2
                },
                "period": 60,
                "title": "Running EC2 Instances Metrics"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_Alarm" {
  alarm_name          = "EC2_CPU_Usage_Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization exceeding 70%"
  alarm_actions       = [aws_sns_topic.example_notification.arn]
  dimensions = {
    InstanceId = "${aws_instance.this.id}"
  }
}

resource "aws_sns_topic" "example_notification" {
  name = var.sns_topic_name

}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_notification.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_sns_topic_policy" "example_policy" {
  arn = aws_sns_topic.example_notification.arn

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "example_policy",
    "Statement" : [
      {
        "Sid" : "statement_1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "SNS:Subscribe",
          "SNS:Publish",
          "SNS:Receive"
        ],
        "Resource" : aws_sns_topic.example_notification.arn,
        "Condition" : {
          "ArnEquals" : {
            "AWS:SourceArn" : aws_sns_topic.example_notification.arn
          },
          "StringEquals" : {
            "AWS:SourceOwner" : data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        "Sid" : "statement_2",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "SNS:Publish"
        ],
        "Resource" : aws_sns_topic.example_notification.arn,
        "Condition" : {
          "ArnEquals" : {
            "AWS:SourceArn" : aws_sns_topic.example_notification.arn
          }
        }
      }
    ]
  })
}

//// cloud trail

resource "aws_s3_bucket" "s3" {
  bucket        = var.s3-bucket-name
  force_destroy = true
}


resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.trail_name}-trail"
  s3_bucket_name                = aws_s3_bucket.s3.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

data "aws_iam_policy_document" "trailpolicy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.s3.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.s3.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
resource "aws_s3_bucket_policy" "bucketpolicy" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.trailpolicy.json
}

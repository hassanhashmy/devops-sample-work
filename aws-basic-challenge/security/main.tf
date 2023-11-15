
provider "aws" {
  region = var.awsregion
}

resource "aws_sns_topic" "sns" {
  name = var.snstopic_name

}

resource "aws_s3_bucket" "s3" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_config_delivery_channel" "delivery" {
  name           = var.config_delivery_channel_name
  s3_bucket_name = aws_s3_bucket.s3.bucket
  sns_topic_arn  = aws_sns_topic.sns.arn
}

resource "aws_config_configuration_recorder" "recorder" {
  name     = var.config_recorder_name
  role_arn = aws_iam_role.role.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.role-name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "s3-policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "${var.policy-name}-policy"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.s3-policy.json
}


resource "aws_config_config_rule" "rule" {
  name = var.rule_name

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }
  depends_on = [
    aws_config_configuration_recorder.recorder
  ]
}

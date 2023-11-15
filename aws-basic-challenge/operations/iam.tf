# Provider Configuration
provider "aws" {
  region = var.region
}

# Define IAM Users
resource "aws_iam_user" "user1" {
  name = var.user1
}

resource "aws_iam_access_key" "user_access_key" {
  user = aws_iam_user.user1.name
}

resource "aws_secretsmanager_secret" "user_secret" {
  name = "user_secret"
}

resource "aws_secretsmanager_secret_version" "user_secret_version" {
  secret_id     = aws_secretsmanager_secret.user_secret.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.user_access_key.id,
    secret_key = aws_iam_access_key.user_access_key.secret
  })
}

# Define IAM Groups
resource "aws_iam_group" "group1" {
  name = var.group_name
}

# Add IAM Users to Groups
resource "aws_iam_group_membership" "user1_to_group1" {
  group = "${aws_iam_group.group1.name}"
  users = ["${aws_iam_user.user1.name}"]
}


# Define IAM Policies
resource "aws_iam_policy" "policy1" {
  name        = "policy1"
  description = "Policy for accessing resources"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach IAM Policies to Groups
resource "aws_iam_group_policy_attachment" "policy1_attachment" {
  group      = "${aws_iam_group.group1.name}"
  policy_arn = "${aws_iam_policy.policy1.arn}"
}




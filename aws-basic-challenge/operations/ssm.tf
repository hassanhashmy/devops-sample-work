locals {
  environment = "dev"

}

resource "aws_iam_role" "session_manager_role" {
  name = "session_manager_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "session_manager_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.session_manager_role.name
}
resource "aws_iam_instance_profile" "session_manager_profile" {
  name = "session_manager_profile"
  role = aws_iam_role.session_manager_role.name
}
resource "aws_security_group" "allow_ssh" {
  name        = "webserver"
  vpc_id      = "vpc-8244c8e9"
  description = "Allows access to ssh Port"
  # allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Env = local.environment
  }
}


resource "aws_instance" "private_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  iam_instance_profile = aws_iam_instance_profile.session_manager_profile.name

  tags = {
    Env = local.environment
  }
}

resource "aws_ssm_document" "session_manager_document" {
  name = "session_manager_document"

  document_type   = "Command"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Start a session with a private EC2 instance"
    parameters = {
      "instanceId" = {
        type        = "String"
        description = "The ID of the instance to start the session on"
      }
    }
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "startSession"
        inputs = {
          runCommand = [
            "aws ssm start-session --target {{instanceId}}"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "session_manager_policy" {
  name   = "SessionManagerPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:StartSession",
        "ssm:DescribeSessions",
        "ssm:TerminateSession",
        "ssm:DescribeInstanceProperties",
        "ec2:describeInstances"
        

      ],
      "Resource": [
       "arn:aws:ec2:*:*:instance/${aws_instance.private_instance.id}",
        "arn:aws:ssm:*:*:*"

    ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:describeInstances"
        
      ],
      "Resource": [
       "*"
        

    ]
    }
    

  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "example_user_policy_attachment" {
  user       = var.user
  policy_arn = aws_iam_policy.session_manager_policy.arn
}

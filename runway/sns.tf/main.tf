provider "aws" {
  region = "eu-west-2"  # You can change this to match your region
}


terraform {
  backend "s3" {
    key = "sns.tfstate"
  }
}

# SNS Topic for RDS Alerts
resource "aws_sns_topic" "uat_alerts" {
  name = "uat-aws-alert"

  tags = {
    Name = "uat-aws-alert"
  }
}

# Optional: IAM policy or role for sending notifications to SNS (if needed)
resource "aws_iam_role" "sns_role" {
  name = "sns-role-for-alerts"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "sns_policy" {
  name = "sns-policy-for-alerts"
  role = aws_iam_role.sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Resource = aws_sns_topic.uat_alerts.arn
        Effect   = "Allow"
      }
    ]
  })
}

# Example: SNS Subscription for an email address (can be customized for other protocols)
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.uat_alerts.arn
  protocol  = "email"
  endpoint  = "bharat.p@technoxander.com"  # Replace with actual email address

  # Confirmation message
  confirmation_timeout_in_minutes = 5
}



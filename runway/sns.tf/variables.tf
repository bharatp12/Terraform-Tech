# variables.tf

variable "region" {
  description = "The AWS region to deploy the SNS topic"
  type        = string
  default     = "eu-west-2"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "uat-aws-alert"
}

variable "email_endpoint" {
  description = "The email address to subscribe to the SNS topic"
  type        = string
  default     = "bharat.p@technoxander.com"  # Replace with actual email
}

variable "environment" {
  description = "The environment for the S3 buckets"
  type        = string
}

variable "region" {
  description = "The AWS region where the S3 buckets will be created"
  default     = "eu-west-2"
}

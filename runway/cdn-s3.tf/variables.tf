# variables.tf

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}


variable "cdn_name" {
  description = "The CloudFront Distribution domain name (CNAME)"
  type        = string
  default = "bankingsuite-newuat.technoxander.com"
}

variable "tf_state_bucket" {
  description = "The S3 bucket that stores the Terraform state"
  type        = string
}

variable "environment" {
  description = "The environment for tagging purposes"
  type        = string
  default = "UAT"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default = "bankingsuite-newuat.technoxander.com"
}

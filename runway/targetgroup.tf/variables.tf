variable "region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-2"
}

variable "interval" {
  description = "Default health check interval"
  type        = number
  default     = 30
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., uat, prod)"
  type        = string
}
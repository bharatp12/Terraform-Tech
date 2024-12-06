# variable.tf


variable "environment" {
  description = "The environment (e.g., uat, prod)"
  type        = string
}

variable "default_tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {
    "Environment" = "UAT"
  }
}

variable "region" {
    type = string
    description = "the region to which infra will be deployed"
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
}


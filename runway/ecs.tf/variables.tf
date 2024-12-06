variable "tf_state_bucket" {
  description = "The S3 bucket that stores the Terraform state"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to (e.g., dev, staging, prod)"
  type        = string
  default     = "uat"
}

variable "region" {
    type = string
    description = "the region to which infra will be deployed"
}
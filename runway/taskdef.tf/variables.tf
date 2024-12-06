variable "region" {
  description = "The AWS region"
  type        = string
}

variable "tf_state_bucket" {
  description = "The S3 bucket where Terraform state is stored"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., uat, prod)"
  type        = string
}

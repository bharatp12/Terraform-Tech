variable "environment" {
  description = "The environment to deploy to (e.g., dev, prod, uat)"
  type        = string
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
}
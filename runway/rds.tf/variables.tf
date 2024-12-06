variable "tf_state_bucket" {
  description = "The S3 bucket that stores the Terraform state"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to (e.g., dev, staging, prod)"
  type        = string
  default     = "uat"
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}



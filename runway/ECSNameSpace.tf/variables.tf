variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "eu-west-2"
}

variable "namespace_name" {
  description = "The name of the Service Discovery namespace"
  type        = string
  default     = "my-service-namespace"
}

variable "namespace_description" {
  description = "A description for the Service Discovery namespace"
  type        = string
  default     = "My ECS Service Discovery Namespace"
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "uat"
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "MyProject"
}

variable "tf_state_bucket" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
}
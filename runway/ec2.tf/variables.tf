variable "tf_state_bucket" {
  description = "The S3 bucket where the Terraform state files are stored"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  default     = "ami-01ec84b284795cbc7"
}

variable "region" {
    type = string
    description = "the region to which infra will be deployed"
}
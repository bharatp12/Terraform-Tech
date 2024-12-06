variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}


variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {
    Environment = "uat"
  }
}

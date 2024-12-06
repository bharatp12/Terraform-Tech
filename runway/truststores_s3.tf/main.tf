provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key = "truststore.tfstate"
  }
}

# Define the S3 bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "uat-mtls-alb-payuk-certificate"  # Name of the bucket


  # Add tags to the bucket
  tags = {
    Environment = "UAT"
  }
}


resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.private_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Upload the certificate file to the S3 bucket
resource "aws_s3_object" "certificate" {
  bucket = aws_s3_bucket.private_bucket.bucket
  key    = "payukcertificate.cer"  # Path inside the bucket
  source = "./certificates/payukcertificate.cer"  # Local path to the certificate file

  # Add tags to the uploaded object
  tags = {
    Environment = "UAT"
  }
}

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    key = "s3.tfstate"
  }
}


resource "aws_s3_bucket" "backend_audit_logs" {
  bucket = "newuat-backend-audit-logs"
  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "Audit Logs"
  }
}

resource "aws_s3_bucket" "uat_api_ob" {
  bucket = "uat-api-ob.technoxander.com"
  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "API Logs"
  }
}

resource "aws_s3_bucket" "uat_technoxander_upload_store" {
  bucket = "uat-technoxander-upload-store"
  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "Upload Store"
  }
}

resource "aws_s3_bucket" "sandbox_newuat" {
  bucket = "sandbox-newuat.technoxander.com"
  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "Sandbox"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = {
    backend_audit_logs       = aws_s3_bucket.backend_audit_logs.id
    uat_api_ob               = aws_s3_bucket.uat_api_ob.id
    uat_technoxander_upload_store = aws_s3_bucket.uat_technoxander_upload_store.id
    sandbox_newuat           = aws_s3_bucket.sandbox_newuat.id
  }

  bucket = each.value
  versioning_configuration {
    status = "Enabled"
  }
}

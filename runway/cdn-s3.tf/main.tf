
## NOTE : Once Deployed go to Route53 and create Record for CDN.

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key = "cdn.tfstate"
  }
}

# Fetch VPC details from remote state
data "terraform_remote_state" "acm-us-east-1" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/acm-us-east-1.tfstate"
  }
}


# Create the S3 bucket using terraform-aws-modules/s3-bucket/aws module
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
//  acl    = "private"  # Restrict access to the bucket

  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "UAT Logs"
  }


}

# Create CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "oac" {
  name                         = "OAC-${var.bucket_name}"
  description                  = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"  # Specifies the origin type (S3 for an S3 bucket)
  signing_behavior             = "always"  # Always sign requests
  signing_protocol             = "sigv4"  # Use Sigv4 for signing
}


# Create CloudFront Distribution using terraform-aws-modules/cloudfront/aws module
module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"

  create_origin_access_control = true
  # origin_access_identities = {
  #   s3_bucket_one = "bsnkingsuite bucket OAC CloudFront can access"
  # }

  origin = {
    something = {
      domain_name = module.s3_bucket.s3_bucket_bucket_domain_name
      origin_id = module.s3_bucket.s3_bucket_id
      origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
      origin_ssl_protocols   = ["TLSv1.2"]
      }
    # s3_one = {
    #   domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    #   s3_origin_config = {
    #     origin_access_identity = "s3_bucket_one"
    #   }
    # }

    }
    
  # Enable CloudFront Distribution
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CDN for ${var.bucket_name}"
  default_root_object = "/index.html"

  # Default cache behavior configuration
  default_cache_behavior = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = module.s3_bucket. s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
  }

  # SSL Settings
  viewer_certificate = {
    acm_certificate_arn = data.terraform_remote_state.acm-us-east-1.outputs.certificate_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # HTTP versions support
  http_version  = "http2and3"

  # CloudFront CNAME (alias) setup
  aliases = [var.cdn_name]
  # custom_error_response = {
  #   error_code         = "403"
  #   response_code      = 403
  #   response_page_path = "/index.html"
  # }

  custom_error_response = [
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 503
      response_code      = 503
      response_page_path = "/index.html"
    }
  ]
  

  # Tags for the CloudFront distribution
  tags = {
    Environment = var.environment
    Project     = "Technoxander"
    Purpose     = "UAT CDN"
  }
  
}

# S3 Bucket Policy to allow CloudFront OAC access
resource "aws_s3_bucket_policy" "allow_cloudfront_oac" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${module.cloudfront.cloudfront_distribution_id}"
                }
            }
        }
    ]
}
EOF
}

# # Define the IAM policy document for the bucket policy
# data "aws_iam_policy_document" "s3_bucket_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${module.s3_bucket.s3_bucket_arn}/*"]

#     principals {
#       type        = "AWS"
#       identifiers = [module.cloudfront.cloudfront_oac_identity_arn]
#     }
#   }
# }



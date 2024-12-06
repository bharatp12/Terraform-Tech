provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "acm.tfstate"
  }
}


resource "aws_acm_certificate" "wildcard_technoxander" {
  domain_name               = "*.technoxander.com"
  validation_method         = "DNS"  # DNS Validation
  key_algorithm             = "RSA_2048"  # RSA 2048 Key algorithm
  
  tags = {
    "Environment" = "uat"
    "Project"     = "wildcard-certificate"
  }

  # DNS validation requires the validation_option block
  validation_option {
    domain_name          = "*.technoxander.com"
    validation_domain    = "technoxander.com"
  }
}





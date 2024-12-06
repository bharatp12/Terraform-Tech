provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    key = "ecsnamespace.tfstate"
  }
}


# Fetch VPC details from remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/vpc.tfstate"
  }
}


resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = var.namespace_name
  description = var.namespace_description
  vpc         = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name        = var.namespace_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_service_discovery_service" "uat_keycloak" {
  name          = "uat-keycloak"  # Service name
  namespace_id  = aws_service_discovery_private_dns_namespace.namespace.id  # Reference to the namespace ID
  description   = "Service for uat-keycloak"

  dns_config {
    # DNS configuration for the service
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id
    dns_records {
      type = "A"  # A record for the service
      ttl  = 60   # TTL in seconds
    }
  }
}
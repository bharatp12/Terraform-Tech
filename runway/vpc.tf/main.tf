provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

terraform {
  backend "s3" {
    key = "vpc.tfstate"
  }
}

resource "aws_eip" "nat" {
  count = var.nat_ip_count
  vpc = true
  lifecycle {
    prevent_destroy = false
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = var.vpc_name
  cidr = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  azs             = var.availability_zones
  private_subnets = cidrsubnets(cidrsubnet(var.vpc_cidr, 4, 1), 2, 4)  # Create 2 private subnets
  public_subnets  = cidrsubnets(cidrsubnet(var.vpc_cidr, 4, 10), 2, 4)  # Create 2 public subnets
  external_nat_ip_ids = "${aws_eip.nat.*.id}"
  reuse_nat_ips = true

  # Tags for Public Subnets with names
  public_subnet_tags = {
    "Public Subnet" = "Environment = ${var.environment}"
  }

  # Tags for Private Subnets with names
  private_subnet_tags = {
    "Private Subnet" = "Environment = ${var.environment}"
  }

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false



  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}

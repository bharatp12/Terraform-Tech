provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "ecr.tfstate"
  }
}

resource "aws_ecr_repository" "clamscan_api" {
  name                 = "clamscan-api"
  image_tag_mutability = "MUTABLE"  # Tag immutability is Mutable
  encryption_configuration {
    encryption_type = "AES256"  # Encryption method
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "clamscan-api"
  }
}

resource "aws_ecr_repository" "uat_cop_requster" {
  name                 = "uat_cop_requster"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_cop_requster"
  }
}

resource "aws_ecr_repository" "uat_cop_requester_dcr" {
  name                 = "uat_cop_requester_dcr"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_cop_requester_dcr"
  }
}

resource "aws_ecr_repository" "uat_cop_responder" {
  name                 = "uat_cop_responder"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_cop_responder"
  }
}

resource "aws_ecr_repository" "uat_cop_responder_dcr" {
  name                 = "uat_cop_responder_dcr"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_cop_responder_dcr"
  }
}

resource "aws_ecr_repository" "uat_cop_responder_integration_layer" {
  name                 = "uat_cop_responder_integration_layer"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_cop_responder_integration_layer"
  }
}

resource "aws_ecr_repository" "uat_nginx" {
  name                 = "uat_nginx"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_nginx"
  }
}

resource "aws_ecr_repository" "uat_uploadlayer" {
  name                 = "uat_uploadlayer"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_uploadlayer"
  }
}

resource "aws_ecr_repository" "uat_keycloak" {
  name                 = "uat_keycloak"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_keycloak"
  }
}

resource "aws_ecr_repository" "uat_vault" {
  name                 = "uat_vault"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_vault"
  }
}

resource "aws_ecr_repository" "uat_nginx_keycloak" {
  name                 = "uat_nginx_keycloak"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = {
    "Environment" = "uat"
    "Project"     = "uat_nginx_keycloak"
  }
}

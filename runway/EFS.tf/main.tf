provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "efs.tfstate"
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

# Fetch SG details from remote state
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/sg.tfstate"
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "efs-${var.environment}"
  performance_mode = "generalPurpose"  # Performance mode (General Purpose)
  throughput_mode = "bursting"         # Throughput mode (Bursting)

  lifecycle {
    prevent_destroy = true  # Prevent destruction of the EFS
  }

  tags = {
    Environment = var.environment
    Name        = "efs-${var.environment}"
  }

  # Optionally enable encryption at rest
  encrypted = true
  
}

resource "aws_efs_mount_target" "efs_mount_target" {
  for_each        = toset(data.terraform_remote_state.vpc.outputs.vpc_private_subnets)  
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.terraform_remote_state.vpc.outputs.vpc_private_subnets[0]
  security_groups = [data.terraform_remote_state.sg.outputs.efs_vault_sg_id]
}

resource "aws_efs_mount_target" "efs_mount_target1" {
  for_each        = toset(data.terraform_remote_state.vpc.outputs.vpc_private_subnets)  
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.terraform_remote_state.vpc.outputs.vpc_private_subnets[1]
  security_groups = [data.terraform_remote_state.sg.outputs.efs_vault_sg_id]
}
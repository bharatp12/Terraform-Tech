provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    key = "ecs.tfstate"
  }
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "uat-cluster"

  # Enable Container Insights for ECS cluster
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name      = "uat-cluster"
    Namespace = "technoxander.com"
  }
}

provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "ecs-service.tfstate"
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

# Fetch Target Group details from remote state
data "terraform_remote_state" "targetgroup" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/targetgroup.tfstate"
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/ecs.tfstate"
  }
}


data "terraform_remote_state" "ecsnamespace" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/ecsnamespace.tfstate"
  }
}


resource "aws_ecs_service" "uat_keycloak" {
  name            = "uat-keycloak"
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_id
  task_definition = "uat_keycloak"
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  
  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = data.terraform_remote_state.vpc.outputs.vpc_private_subnets
    security_groups  = [data.terraform_remote_state.sg.outputs.keycloak_sg_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = data.terraform_remote_state.ecsnamespace.outputs.service_discovery_service_arn
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.targetgroup.outputs.target_group_uat_keycloak_non_mtls
    container_name   = "nginx"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.targetgroup.outputs.target_group_uat_keycloak_mtls
    container_name   = "nginx"
    container_port   = 80
  }  

  health_check_grace_period_seconds = 120
  enable_ecs_managed_tags           = true
  propagate_tags                    = "SERVICE"
  
  tags = {
    Name        = "uat-keycloak"
    Environment = "uat"
    Project     = "TechnoXander"
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}

resource "aws_service_discovery_service" "uat_keycloak" {
  name        = "uat-keycloak"
  namespace_id = data.terraform_remote_state.ecsnamespace.outputs.service_discovery_namespace_id
  description = "uat-keycloak-DNS"

  dns_config {
    namespace_id = data.terraform_remote_state.ecsnamespace.outputs.service_discovery_namespace_id
    routing_policy = "MULTIVALUE"
    dns_records {
      type  = "A"
      ttl   = 60
    }
  }
}

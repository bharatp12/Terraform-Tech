provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key = "taskdef.tfstate"
  }
}

# Fetch task role and execution role from remote state
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/iam.tfstate"
  }
}


resource "aws_ecs_task_definition" "uat_keycloak" {
  family                   = "uat-keycloak"
  execution_role_arn       = data.terraform_remote_state.iam.outputs.uat_keycloak_arn
  task_role_arn            = data.terraform_remote_state.iam.outputs.uat_keycloak_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"

  runtime_platform = {
    cpuArchitecture = "ARM64"
    operatingSystemFamily = "LINUX"
  }


  container_definitions = jsondecode(file("${path.module}/uat-keycloak.json"))
}

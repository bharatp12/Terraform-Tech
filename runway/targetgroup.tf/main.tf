provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key = "targetgroup.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/vpc.tfstate"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/ec2.tfstate"
  }
}

resource "aws_lb_target_group" "uat_elk" {
  name        = "uat-elk"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299,400-499,302"
  }
  tags = {
    Name = "uat-elk"
  }
}

# Attach the EC2 instance to the target group
resource "aws_lb_target_group_attachment" "uat_elk_attachment" {
  target_group_arn = aws_lb_target_group.uat_elk.arn  # Target group ARN from your existing resource
  target_id        = data.terraform_remote_state.ec2.outputs.uat_elk_id  # EC2 instance ID from remote state
  port             = 5601  # Port 5601 for ELK (or whatever your service uses)
}


resource "aws_lb_target_group" "uptime_kuma_monitor" {
  name        = "uptime-kuma-monitor"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uptime-kuma-monitor"
  }
}

resource "aws_lb_target_group" "uat_keycloak_mtls" {
  name        = "uat-keycloak-mtls"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-keycloak-mtls"
  }
}

resource "aws_lb_target_group" "uat_keycloak_non_mtls" {
  name        = "uat-keycloak-non-mtls"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-keycloak-non-mtls"
  }
}

resource "aws_lb_target_group" "uat_requester" {
  name        = "uat-requester"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/cop/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-requester"
  }
}

resource "aws_lb_target_group" "uat_requester_dcr" {
  name        = "uat-requester-dcr"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/cop/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-requester-dcr"
  }
}

resource "aws_lb_target_group" "uat_res_int_layer" {
  name        = "uat-res-int-layer"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/cop-integration/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-res-int-layer"
  }
}

resource "aws_lb_target_group" "uat_responder" {
  name        = "uat-responder"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-responder"
  }
}

resource "aws_lb_target_group" "uat_responder_dcr" {
  name        = "uat-responder-dcr"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/actuator/health"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-responder-dcr"
  }
}

resource "aws_lb_target_group" "uat_upload_layer_non_mtls" {
  name        = "uat-upload-layer-non-mtls"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/upload/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-upload-layer-non-mtls"
  }
}

resource "aws_lb_target_group" "uat_upload_layer_mtls" {
  name        = "uat-upload-layer-mtls"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/open-banking/v3.3/upload/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-upload-layer-mtls"
  }
}

resource "aws_lb_target_group" "uat_nginx_mtls" {
  name        = "uat-nginx-mtls"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-nginx-mtls"
  }
}

resource "aws_lb_target_group" "uat_nginx_non_mtls" {
  name        = "uat-nginx-non-mtls"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = {
    Name = "uat-nginx-non-mtls"
  }
}

resource "aws_lb_target_group" "uat_vault" {
  name        = "uat-vault"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/v1/sys/health"
    interval            = 90
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200,403,401,404,400"
  }
  tags = {
    Name = "uat-vault"
  }
}

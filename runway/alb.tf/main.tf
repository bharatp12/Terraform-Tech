provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "alb.tfstate"
  }
}


# Fetch VPC outputs (including public subnets) from remote state
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

# Fetch SG details from remote state
data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/acm.tfstate"
  }
}

data "terraform_remote_state" "targetgroup" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/targetgroup.tfstate"
  }
}

resource "aws_lb" "uat_mtls" {
  name               = "uat-mtls"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.sg.outputs.mtls_alb_sg_id]
  subnets            = data.terraform_remote_state.vpc.outputs.vpc_public_subnets
  ip_address_type    = "ipv4"

  tags = {
    Name        = "uat-mtls"
    Environment = "uat"
    Project     = "mtls-alb"
  }
}

resource "aws_lb" "uat_non_mtls" {
  name               = "uat-non-mtls"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.sg.outputs.nonmtls_alb_sg_id]
  subnets            = data.terraform_remote_state.vpc.outputs.vpc_public_subnets
  ip_address_type    = "ipv4"

  tags = {
    Name        = "uat-non-mtls"
    Environment = "uat"
    Project     = "non-mtls-alb"
  }
}

# Listener for port 80 on the uat_mtls ALB
resource "aws_lb_listener" "uat_mtls_http" {
  load_balancer_arn = aws_lb.uat_mtls.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      host         = "#{host}"
      path         = "/#{path}"
      query        = "#{query}"
      port         = "443"
      protocol     = "HTTPS"
    }
  }
}

# Listener for port 80 and 443 on the uat_non_mtls ALB
resource "aws_lb_listener" "uat_non_mtls_http" {
  load_balancer_arn = aws_lb.uat_non_mtls.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      host         = "#{host}"
      path         = "/#{path}"
      query        = "#{query}"
      port         = "443"
      protocol     = "HTTPS"
    }
  }
}

### 443 Listener add 

resource "aws_lb_listener" "uat_non_mtls_https" {
  load_balancer_arn = aws_lb.uat_non_mtls.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.terraform_remote_state.acm.outputs.certificate_arn  # Attach ACM certificate

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code = 503
      message_body = "Service Unavailable"
      content_type = "text/plain"
    }
  }
}


resource "aws_lb_listener" "uat_mtls_https" {
  load_balancer_arn = aws_lb.uat_mtls.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.terraform_remote_state.acm.outputs.certificate_arn  # Attach ACM certificate

  # Default action for the listener if no rules match
  default_action {
    type = "fixed-response"
    fixed_response {
      status_code = 503
      message_body = "Service Unavailable"
      content_type = "text/plain"
    }
  }

  # Enable mTLS (Mutual TLS) with full verification and specify the Trust Store ARN
  mutual_authentication {
      trust_store_arn    = "arn:aws:elasticloadbalancing:eu-west-2:842676014640:truststore/uat-mtls-alb-payuk-certificate/b009f6c22d3ca766"  # Trust Store ARN
      mode = "verify"  # Full verification of client certificates
    }
}


## Add a listener rule for matching the Host header and forwarding to the target group

resource "aws_lb_listener_rule" "uat_non_mtls_https_rule" {
  listener_arn = aws_lb_listener.uat_non_mtls_https.arn

  condition {
    host_header {
      values = ["uat-elk.technoxander.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = data.terraform_remote_state.targetgroup.outputs.target_group_uat_elk
  }

  priority = 2  # The priority for the rule. Rules with lower numbers have higher priority.
}

## Keycloak Rules

resource "aws_lb_listener_rule" "uat_non_mtls_keycloak_rule" {
  listener_arn = aws_lb_listener.uat_non_mtls_https.arn

  condition {
    host_header {
      values = ["ob-newuatauth.technoxander.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = data.terraform_remote_state.targetgroup.outputs.target_group_uat_keycloak_non_mtls
  }

  priority = 3  # The priority for the rule. Rules with lower numbers have higher priority.
}

resource "aws_lb_listener_rule" "uat_mtls_keycloak_rule" {
  listener_arn = aws_lb_listener.uat_mtls_https.arn

  condition {
    host_header {
      values = ["newuatauth.technoxander.com"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = data.terraform_remote_state.targetgroup.outputs.target_group_uat_keycloak_mtls
  }

  priority = 2  # The priority for the rule. Rules with lower numbers have higher priority.
}


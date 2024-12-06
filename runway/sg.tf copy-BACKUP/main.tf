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
    key = "sg.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/vpc.tfstate"
  }
}

# Define Security Group for RDS
resource "aws_security_group" "rds_uat" {
  name        = "rds-uat"
  description = "Security Group for RDS in UAT"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow only necessary ports (e.g., MySQL, PostgreSQL, etc.)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Adjust according to your network needs
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-uat"
    Environment = var.environment
  }
}

# Define Security Group for Jenkins EC2
resource "aws_security_group" "ec2_uat_jenkins" {
  name        = "ec2-uat-jenkins"
  description = "Security Group for EC2 Jenkins in UAT"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow SSH from specific IP range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Adjust to only allow specific IPs or ranges
  }

  # Inbound: Allow HTTP/HTTPS for Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-uat-jenkins"
    Environment = var.environment
  }
}

# Define Security Group for ELK EC2
resource "aws_security_group" "ec2_uat_elk" {
  name        = "ec2-uat-elk"
  description = "Security Group for EC2 ELK stack in UAT"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow specific ports for ELK stack (e.g., 9200 for Elasticsearch, 5601 for Kibana)
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-uat-elk"
    Environment = var.environment
  }
}

# Define Security Group for Bastion Host
resource "aws_security_group" "ec2_uat_bastionhost" {
  name        = "ec2-uat-bastionhost"
  description = "Security Group for EC2 Bastion Host in UAT"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow SSH from specific IP range for Bastion Host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Limit access from trusted IPs
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-uat-bastionhost"
    Environment = var.environment
  }
}

# Define Security Group for mTLS ALB
resource "aws_security_group" "uat_mtls_alb" {
  name        = "uat-mtls-alb"
  description = "Security Group for UAT mTLS Application Load Balancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-mtls-alb"
    Environment = var.environment
  }
}

# Define Security Group for non-mTLS ALB
resource "aws_security_group" "uat_nonmtls_alb" {
  name        = "uat-nonmtls-alb"
  description = "Security Group for UAT non-mTLS Application Load Balancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow HTTP/HTTPS traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-nonmtls-alb"
    Environment = var.environment
  }
}

# Define Security Group for Keycloak
resource "aws_security_group" "uat_keycloak" {
  name        = "uat-keycloak"
  description = "Security Group for UAT Keycloak"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow HTTP/HTTPS for Keycloak
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-keycloak"
    Environment = var.environment
  }
}

# Define Security Group for NGINX
resource "aws_security_group" "uat_nginx" {
  name        = "uat-nginx"
  description = "Security Group for UAT NGINX"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow HTTP/HTTPS for NGINX
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-nginx"
    Environment = var.environment
  }
}

# Define Security Group for Responder
resource "aws_security_group" "uat_responder" {
  name        = "uat-responder"
  description = "Security Group for UAT Responder"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Responder
  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-responder"
    Environment = var.environment
  }
}

# Define Security Group for Responder
resource "aws_security_group" "uat_responder_dcr" {
  name        = "uat-responder-dcr"
  description = "Security Group for UAT Responder DCR"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Responder
  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-responder-dcr"
    Environment = var.environment
  }
}


# Define Security Group for Requester
resource "aws_security_group" "uat_requester" {
  name        = "uat-requester"
  description = "Security Group for UAT Requester"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Requester
  ingress {
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-requester"
    Environment = var.environment
  }
}

# Define Security Group for Requester
resource "aws_security_group" "uat_requester_dcr" {
  name        = "uat-requester-dcr"
  description = "Security Group for UAT Requester"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Requester
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-requester-dcr"
    Environment = var.environment
  }
}

# Define Security Group for Requester
resource "aws_security_group" "uat_int_layer" {
  name        = "uat-int-layer"
  description = "Security Group for UAT Requester"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Requester
  ingress {
    from_port   = 8087
    to_port     = 8087
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-int-layer"
    Environment = var.environment
  }
}

# Define Security Group for Requester
resource "aws_security_group" "uat_uploadlayer" {
  name        = "uat-uploadlayer"
  description = "Security Group for UAT Requester"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Requester
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-uploadlayer"
    Environment = var.environment
  }
}


# Define Security Group for Vault
resource "aws_security_group" "uat_vault" {
  name        = "uat-vault"
  description = "Security Group for UAT Vault"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow necessary ports for Vault
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-vault"
    Environment = var.environment
  }
}

# Define Security Group for EFS Vault
resource "aws_security_group" "uat_efs_vault" {
  name        = "uat-EFS-vault"
  description = "Security Group for EFS Vault in UAT"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Inbound: Allow NFS traffic for EFS
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Outbound: Allow all outbound traffic (default is open)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "uat-EFS-vault"
    Environment = var.environment
  }
}



# Add any other necessary security groups following the same pattern as above...

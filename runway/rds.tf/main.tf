provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "rds.tfstate"
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

# Fetch SNS topic ARN from remote state
data "terraform_remote_state" "sns" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/sns.tfstate"
  }
}

resource "aws_db_subnet_group" "uat_db_subnet_group" {
  name       = "uat-db-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.vpc_private_subnets  # Fetch private subnets from remote state

  tags = {
    Name        = "uat-db-subnet-group"
    Environment = var.environment
  }
}

# RDS instance configuration
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  # RDS configuration
  identifier         = "uat-rds"
  engine                = "postgres"
  engine_version        = "16.3"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  storage_type          = "gp3"
  multi_az              = false
  publicly_accessible   = false
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.rds_sg_id]
  enabled_cloudwatch_logs_exports = ["postgresql"]
  performance_insights_enabled = true
  # DB Subnet Group
  db_subnet_group_name  = "uat-db-subnet-group"
  subnet_ids           = data.terraform_remote_state.vpc.outputs.vpc_private_subnets

  # Database credentials
  username             = "technouatadmin"
  password             = "elVRLYfM2JvBZVWJd4K07rKspgtgn40zwXFq"  # Replace with secure storage

  # Backup and maintenance
  backup_retention_period = 7
  maintenance_window      = "Sun:04:00-Sun:04:30"

  # Parameter Group (force SSL connections)
  parameter_group_name = "uat-rds-parameter-group"
  parameters = [
    {
      name  = "rds.force_ssl"
      value = "1"
    }
  ]

  # Encryption using default AWS KMS
  storage_encrypted = true
  kms_key_id        = null
  family = "postgres16"

  tags = {
    Name        = "uat-rds"
    Environment = var.environment
    Project     = "Technoxander"
  }
}

# CloudWatch Alarms for RDS CPU, Memory, and Storage
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name                = "cpu-usage-70"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 2
  threshold                 = 70
  comparison_operator       = "GreaterThanThreshold"
  alarm_description         = "Trigger when CPU usage exceeds 70%"
  actions_enabled           = true
  alarm_actions             = [data.terraform_remote_state.sns.outputs.sns_topic_arn]
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name                = "memory-usage-70"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 2
  threshold                 = 70
  comparison_operator       = "LessThanThreshold"
  alarm_description         = "Trigger when Freeable Memory is below 70%"
  actions_enabled           = true
  alarm_actions             = [data.terraform_remote_state.sns.outputs.sns_topic_arn]
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "storage_alarm" {
  alarm_name                = "storage-usage-70"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 2
  threshold                 = 70
  comparison_operator       = "LessThanThreshold"
  alarm_description         = "Trigger when Free Storage Space is below 70%"
  actions_enabled           = true
  alarm_actions             = [data.terraform_remote_state.sns.outputs.sns_topic_arn]
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }
}


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
    key = "ec2.tfstate"
  }
}



# Fetch VPC information from remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/vpc.tfstate"
  }
}

# Fetch Security Groups from remote state
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/sg.tfstate"
  }
}

# Fetch IAM roles from remote state
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "env:/${var.environment}/iam.tfstate"
  }
}




resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.vpc_public_subnets, 0)  # First public subnet
  key_name               = "Bastion-Host-Uat.pem"
  security_groups        = [data.terraform_remote_state.sg.outputs.ec2_bastionhost_sg_id] # Fetch from remote state
  associate_public_ip_address = true
  tags = {
    Name = "bastion-host"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = true
    kms_key_id  = "alias/aws/ebs"
  }

  disable_api_termination = true
}

resource "aws_instance" "uat_elk" {
  ami                    = var.ami_id
  instance_type          = "c5.large"
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.vpc_private_subnets, 0)
  key_name               = "Uat-ELK.pem"
  security_groups        = [data.terraform_remote_state.sg.outputs.ec2_elk_sg_id] # Fetch from remote state
  associate_public_ip_address = false
  disable_api_termination = true
  tags = {
    Name = "uat-elk"
  }
 
  root_block_device {
    volume_size = 40
    volume_type = "gp2"
    encrypted   = true
    kms_key_id  = "alias/aws/ebs"
  }

 # iam_instance_profile = data.terraform_remote_state.iam.outputs.ec2_instance_profile_arn
  iam_instance_profile = "Uat-ELK"
}


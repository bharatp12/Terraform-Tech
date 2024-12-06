provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key = "iam.tfstate"
  }
}


resource "aws_iam_policy" "EFSMountPolicyTerraform" {
  name        = "EFSMountPolicyTerraform"
  description = "Custom policy for ECS task execution"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:DescribeMountTargets"
        ]
        Resource  = "arn:aws:elasticfilesystem:eu-west-2:985539776911:file-system/fs-0b7d00f3c332f26de"
      }
    ]
  })
}

# Step 1: Create the custom IAM Policy
resource "aws_iam_policy" "ECSTaskExecutionRolePolicyTerraform" {
  name        = "ECSTaskExecutionRolePolicyTerraform"
  description = "Custom policy for ECS task execution"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource  = "*"
      }
    ]
  })
}

# Step 2: Create IAM Roles
resource "aws_iam_role" "uat_cop_responder" {
  name = "uat_cop_responder"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_keycloak" {
  name = "uat_keycloak"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })


  inline_policy {
    name   = "SecretsManagerPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ]
          Resource = [
            "arn:aws:secretsmanager:eu-west-2:842676014640:secret:Uat-keycloak-Dbn5oo"
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:ListSecrets"
          ]
          Resource = "*"
        }
      ]
    })
  }
  inline_policy {
    name   = "CloudWatchLogsPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:aws:logs:eu-west-2:842676014640:log-group:/ecs/*"
        }
      ]
    })
  }

}

resource "aws_iam_role" "uat_cop_requester_dcr" {
  name = "uat_cop_requester_dcr"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_cop_requester" {
  name = "uat_cop_requester"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_cop_responder_dcr" {
  name = "uat_cop_responder_dcr"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_cop_responder_integration_layer" {
  name = "uat_cop_responder_integration_layer"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_vault" {
  name = "uat_vault"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

# New Roles: uat-Jenkins and uatelk

resource "aws_iam_role" "uat_Jenkins" {
  name = "uat-Jenkins"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "uat_ELK" {
  name = "Uat-ELK"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

#Instnace Profile Attach to EC2

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "Uat-ELK"
  role = aws_iam_role.uat_ELK.name
}


# Step 3: Attach the custom policy to all the IAM roles
resource "aws_iam_role_policy_attachment" "uat_cop_responder_policy" {
  role       = aws_iam_role.uat_cop_responder.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_keycloak_policy" {
  role       = aws_iam_role.uat_keycloak.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_cop_requester_dcr_policy" {
  role       = aws_iam_role.uat_cop_requester_dcr.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_cop_requester_policy" {
  role       = aws_iam_role.uat_cop_requester.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_cop_responder_dcr_policy" {
  role       = aws_iam_role.uat_cop_responder_dcr.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_cop_responder_integration_layer_policy" {
  role       = aws_iam_role.uat_cop_responder_integration_layer.name
  policy_arn = aws_iam_policy.ECSTaskExecutionRolePolicyTerraform.arn
}

resource "aws_iam_role_policy_attachment" "uat_vault_policy" {
  role       = aws_iam_role.uat_vault.name
  policy_arn = aws_iam_policy.EFSMountPolicyTerraform.arn
}



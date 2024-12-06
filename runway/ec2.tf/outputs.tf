# Fetch the VPC and Subnet IDs from remote state
output "vpc_id" {
  description = "The VPC ID"
  value       = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "bastion_host_id" {
  description = "The instance ID of the Bastion Host"
  value       = aws_instance.bastion_host.id
}

output "uat_elk_id" {
  description = "The instance ID of the UAT ELK"
  value       = aws_instance.uat_elk.id
}

output "bastion_host_public_ip" {
  description = "The public IP of the Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}

output "uat_elk_private_ip" {
  description = "The private IP of the UAT ELK"
  value       = aws_instance.uat_elk.private_ip
}

output "uat_elk_iam_role_arn" {
  description = "IAM role ARN for UAT ELK"
  value       = data.terraform_remote_state.iam.outputs.uat_elk
}

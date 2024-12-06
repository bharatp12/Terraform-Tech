output "uat_cop_responder_arn" {
  description = "ARN of the uat_cop_responder role"
  value       = aws_iam_role.uat_cop_responder.arn
}

output "uat_keycloak_arn" {
  description = "ARN of the uat_keycloak role"
  value       = aws_iam_role.uat_keycloak.arn
}

output "uat_cop_requester_dcr_arn" {
  description = "ARN of the uat_cop_requester_dcr role"
  value       = aws_iam_role.uat_cop_requester_dcr.arn
}

output "uat_cop_requester_arn" {
  description = "ARN of the uat_cop_requester role"
  value       = aws_iam_role.uat_cop_requester.arn
}

output "uat_cop_responder_dcr_arn" {
  description = "ARN of the uat_cop_responder_dcr role"
  value       = aws_iam_role.uat_cop_responder_dcr.arn
}

output "uat_cop_responder_integration_layer_arn" {
  description = "ARN of the uat_cop_responder_integration_layer role"
  value       = aws_iam_role.uat_cop_responder_integration_layer.arn
}

output "uat_vault_arn" {
  description = "ARN of the uat_cop_responder_integration_layer role"
  value       = aws_iam_role.uat_vault.arn
}

output "uat_jenkins" {
  description = "ARN of the uat_jenkins role"
  value       = aws_iam_role.uat_Jenkins.arn
}

output "uat_elk" {
  description = "ARN of the uat_elk role"
  value       = aws_iam_role.uat_ELK.arn
}

output "iam_instance_profile_name" {
  description = "The name of the IAM instance profile associated with the EC2 instance"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ec2_instance_profile_arn" {
  description = "The ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}
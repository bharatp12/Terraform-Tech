output "Uat_Vault_secret_arn" {
  value = aws_secretsmanager_secret.Uat_Vault.arn
}

output "Uat_keycloak_secret_arn" {
  value = aws_secretsmanager_secret.Uat_keycloak.arn
}

output "uat_cop_requester_secret_arn" {
  value = aws_secretsmanager_secret.uat_cop_requester.arn
}

output "uat_cop_requester_dcr_secret_arn" {
  value = aws_secretsmanager_secret.uat_cop_requester_dcr.arn
}

output "Uat_cop_responder_secret_arn" {
  value = aws_secretsmanager_secret.Uat_cop_responder.arn
}

output "Uat_cop_responder_integration_layer_secret_arn" {
  value = aws_secretsmanager_secret.Uat_cop_responder_integration_layer.arn
}

output "Uat_cop_uploadLayer_secret_arn" {
  value = aws_secretsmanager_secret.Uat_cop_uploadLayer.arn
}

output "Uat_cop_responder_dcr_secret_arn" {
  value = aws_secretsmanager_secret.Uat_cop_responder_dcr.arn
  description = "The ARN of the Uat-cop_responder_dcr secret"
}

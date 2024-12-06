output "clamscan_api_uri" {
  value = aws_ecr_repository.clamscan_api.repository_url
}

output "uat_cop_requster_uri" {
  value = aws_ecr_repository.uat_cop_requster.repository_url
}

output "uat_cop_requester_dcr_uri" {
  value = aws_ecr_repository.uat_cop_requester_dcr.repository_url
}

output "uat_cop_responder_uri" {
  value = aws_ecr_repository.uat_cop_responder.repository_url
}

output "uat_cop_responder_dcr_uri" {
  value = aws_ecr_repository.uat_cop_responder_dcr.repository_url
}

output "uat_cop_responder_integration_layer_uri" {
  value = aws_ecr_repository.uat_cop_responder_integration_layer.repository_url
}

output "uat_nginx_uri" {
  value = aws_ecr_repository.uat_nginx.repository_url
}

output "uat_uploadlayer_uri" {
  value = aws_ecr_repository.uat_uploadlayer.repository_url
}

output "uat_keycloak_uri" {
  value = aws_ecr_repository.uat_keycloak.repository_url
}

output "uat_vault_uri" {
  value = aws_ecr_repository.uat_vault.repository_url
}

output "uat_nginx_keycloak" {
  value = aws_ecr_repository.uat_nginx_keycloak.repository_url
}

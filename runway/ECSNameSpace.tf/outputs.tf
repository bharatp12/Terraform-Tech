output "service_discovery_namespace_id" {
  description = "The ID of the Service Discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.id
}

output "service_discovery_namespace_name" {
  description = "The name of the Service Discovery namespace"
  value       = aws_service_discovery_private_dns_namespace.namespace.name
}

output "service_discovery_private_dns_namespace_arn" {
  description = "The ARN of the Service Discovery Private DNS Namespace."
  value       = aws_service_discovery_private_dns_namespace.namespace.arn
}

output "service_discovery_service_arn" {
  description = "The ARN of the uat-keycloak service in AWS Cloud Map"
  value       = aws_service_discovery_service.uat_keycloak.arn
}

# output "service_discovery_dns_name" {
#   description = "The DNS name of the uat-keycloak service"
#   value       = aws_service_discovery_service.uat_keycloak.dns_config[0].dns_records[0].name
# }

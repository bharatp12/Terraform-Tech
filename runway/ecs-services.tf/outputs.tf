output "ecs_service_name" {
  description = "The name of the ECS Service"
  value       = aws_ecs_service.uat_keycloak.name
}

output "ecs_service_arn" {
  description = "The ARN of the ECS Service"
  value       = aws_ecs_service.uat_keycloak.id
}

output "service_discovery_service_name" {
  description = "The name of the Service Discovery service"
  value       = aws_service_discovery_service.uat_keycloak.name
}

output "service_discovery_service_id" {
  description = "The ID of the Service Discovery service"
  value       = aws_service_discovery_service.uat_keycloak.id
}

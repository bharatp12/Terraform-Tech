output "uat_keycloak_taskdef_arn" {
  description = "The ARN of the ECS task definition for Keycloak"
  value       = aws_ecs_task_definition.uat_keycloak.arn
}

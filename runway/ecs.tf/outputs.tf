output "ecs_cluster_id" {
  description = "The ECS Cluster ID"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  description = "The ECS Cluster Name"
  value       = aws_ecs_cluster.ecs_cluster.name
}

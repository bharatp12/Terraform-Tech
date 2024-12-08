
output "efs_id" {
  description = "The ID of the created EFS file system"
  value       = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
  description = "The DNS name of the created EFS file system"
  value       = aws_efs_file_system.efs.dns_name
}

output "efs_arn" {
  value = aws_efs_file_system.efs.arn
}

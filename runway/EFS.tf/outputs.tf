
output "efs_id" {
  description = "The ID of the created EFS file system"
  value       = aws_efs_file_system.efs.id
}

output "efs_dns_name" {
  description = "The DNS name of the created EFS file system"
  value       = aws_efs_file_system.efs.dns_name
}

output "efs_mount_target_id" {
  description = "The ID of the EFS mount target"
  value       = aws_efs_mount_target.efs_mount_target.id
}

output "efs_mount_target_subnet_id" {
  description = "The subnet ID of the EFS mount target"
  value       = aws_efs_mount_target.efs_mount_target.subnet_id
}

output "efs_mount_target_subnet_id1" {
  description = "The subnet ID of the EFS mount target"
  value       = aws_efs_mount_target.efs_mount_target1.subnet_id
}

output "efs_mount_target_security_groups" {
  description = "The security group IDs of the EFS mount target"
  value       = aws_efs_mount_target.efs_mount_target.security_groups
}


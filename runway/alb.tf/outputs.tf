output "uat_mtls_lb_arn" {
  description = "The ARN of the uat-mtls ALB"
  value       = aws_lb.uat_mtls.arn
}

output "uat_non_mtls_lb_arn" {
  description = "The ARN of the uat-non-mtls ALB"
  value       = aws_lb.uat_non_mtls.arn
}


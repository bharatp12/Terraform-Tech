# outputs.tf

output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.uat_alerts.arn
}

output "sns_topic_name" {
  description = "The name of the SNS topic"
  value       = aws_sns_topic.uat_alerts.name
}
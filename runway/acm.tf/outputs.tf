output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.wildcard_technoxander.arn
}

output "dns_validation_record_name" {
  description = "The DNS validation record name"
  value = join("", [for option in aws_acm_certificate.wildcard_technoxander.domain_validation_options : option.resource_record_name])
}

output "dns_validation_record_value" {
  description = "The DNS validation record value"
  value = join("", [for option in aws_acm_certificate.wildcard_technoxander.domain_validation_options : option.resource_record_value])
}

# outputs.tf

output "s3_bucket_name" {
  description = "The name of the created S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name 
}

output "s3_bucket_domain_name_regional" {
  description = "The domain name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_bucket_regional_domain_name 
}

output "cloudfront_distribution_id" {
  description = "The CloudFront Distribution ID"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "The CloudFront Distribution Domain Name"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

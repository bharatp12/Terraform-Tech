output "backend_audit_logs_bucket_name" {
  value = aws_s3_bucket.backend_audit_logs.bucket
}

output "uat_api_ob_bucket_name" {
  value = aws_s3_bucket.uat_api_ob.bucket
}

output "uat_technoxander_upload_store_bucket_name" {
  value = aws_s3_bucket.uat_technoxander_upload_store.bucket
}

output "sandbox_newuat_bucket_name" {
  value = aws_s3_bucket.sandbox_newuat.bucket
}

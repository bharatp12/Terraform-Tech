output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "rds_instance_id" {
  value = module.rds.db_instance_identifier
}

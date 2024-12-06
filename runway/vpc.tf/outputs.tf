
output "vpc_private_subnets" {
  description = "The private subnets of the vpc"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "The public subnets of the vpc"
  value = module.vpc.public_subnets
}


output "vpc_id" {
  description = "The OIDC URL"
  value = module.vpc.vpc_id
}





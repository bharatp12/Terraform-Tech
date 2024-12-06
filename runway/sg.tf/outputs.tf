# output.tf

output "rds_sg_id" {
  value = aws_security_group.rds_uat.id
}

output "ec2_jenkins_sg_id" {
  value = aws_security_group.ec2_uat_jenkins.id
}

output "ec2_elk_sg_id" {
  value = aws_security_group.ec2_uat_elk.id
}

output "ec2_bastionhost_sg_id" {
  value = aws_security_group.ec2_uat_bastionhost.id
}

output "mtls_alb_sg_id" {
  value = aws_security_group.uat_mtls_alb.id
}

output "nonmtls_alb_sg_id" {
  value = aws_security_group.uat_nonmtls_alb.id
}

output "keycloak_sg_id" {
  value = aws_security_group.uat_keycloak.id
}

output "nginx_sg_id" {
  value = aws_security_group.uat_nginx.id
}

output "responder_sg_id" {
  value = aws_security_group.uat_responder.id
}

output "requester_sg_id" {
  value = aws_security_group.uat_requester.id
}

output "responder_dcr_sg_id" {
  value = aws_security_group.uat_responder_dcr.id
}

output "requester_dcr_sg_id" {
  value = aws_security_group.uat_requester_dcr.id
}

output "uploadlayer_sg_id" {
  value = aws_security_group.uat_uploadlayer.id
}

output "int_layer_sg_id" {
  value = aws_security_group.uat_int_layer.id
}

output "vault_sg_id" {
  value = aws_security_group.uat_vault.id
}

output "efs_vault_sg_id" {
  value = aws_security_group.uat_efs_vault.id
}

output "target_group_uat_elk" {
  value = aws_lb_target_group.uat_elk.id
}

output "target_group_uptime_kuma_monitor" {
  value = aws_lb_target_group.uptime_kuma_monitor.id
}

output "target_group_uat_keycloak_mtls" {
  value = aws_lb_target_group.uat_keycloak_mtls.id
}

output "target_group_uat_keycloak_non_mtls" {
  value = aws_lb_target_group.uat_keycloak_non_mtls.id
}

output "target_group_uat_requester" {
  value = aws_lb_target_group.uat_requester.id
}

output "target_group_uat_requester_dcr" {
  value = aws_lb_target_group.uat_requester_dcr.id
}

output "target_group_uat_res_int_layer" {
  value = aws_lb_target_group.uat_res_int_layer.id
}

output "target_group_uat_responder" {
  value = aws_lb_target_group.uat_responder.id
}

output "target_group_uat_responder_dcr" {
  value = aws_lb_target_group.uat_responder_dcr.id
}

output "target_group_uat_upload_layer_non_mtls" {
  value = aws_lb_target_group.uat_upload_layer_non_mtls.id
}

output "target_group_uat_upload_layer_mtls" {
  value = aws_lb_target_group.uat_upload_layer_mtls.id
}

output "target_group_uat_nginx_mtls" {
  value = aws_lb_target_group.uat_nginx_mtls.id
}

output "target_group_uat_nginx_non_mtls" {
  value = aws_lb_target_group.uat_nginx_non_mtls.id
}

output "target_group_uat_vault" {
  value = aws_lb_target_group.uat_vault.id
}

output "uat_elk_target_group_attachment" {
  description = "The attachment of the EC2 instance to the target group"
  value       = aws_lb_target_group_attachment.uat_elk_attachment.id
}

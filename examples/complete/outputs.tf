output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.log_monitoring_alarming.this_vpc_id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = module.log_monitoring_alarming.this_vswitch_id
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = module.log_monitoring_alarming.this_security_group_id
}

output "ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = module.log_monitoring_alarming.this_ecs_instance_ids
}

output "ecs_instance_private_ips" {
  description = "The private IP addresses of the ECS instances"
  value       = module.log_monitoring_alarming.this_ecs_instance_private_ips
}

output "sls_project_name" {
  description = "The name of the SLS project"
  value       = module.log_monitoring_alarming.this_sls_project_name
}

output "sls_logstore_name" {
  description = "The name of the SLS log store"
  value       = module.log_monitoring_alarming.this_sls_logstore_name
}

output "ecs_login_address" {
  description = "The ECS login address for viewing generated logs"
  value       = module.log_monitoring_alarming.this_ecs_login_address
}

output "sls_logsearch_url" {
  description = "The SLS log search URL"
  value       = module.log_monitoring_alarming.this_sls_logsearch_url
}

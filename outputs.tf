output "this_vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "this_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

output "this_vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "this_vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = alicloud_vswitch.vswitch.cidr_block
}

output "this_security_group_id" {
  description = "The ID of the Security Group"
  value       = alicloud_security_group.security_group.id
}

output "this_ecs_instance_ids" {
  description = "The IDs of the ECS instances"
  value       = alicloud_instance.ecs_instance[*].id
}

output "this_ecs_instance_private_ips" {
  description = "The private IP addresses of the ECS instances"
  value       = alicloud_instance.ecs_instance[*].primary_ip_address
}

output "this_ecs_instance_public_ips" {
  description = "The public IP addresses of the ECS instances"
  value       = alicloud_instance.ecs_instance[*].public_ip
}

output "this_ram_user_name" {
  description = "The name of the RAM user"
  value       = alicloud_ram_user.ram_user.name
}

output "this_ram_access_key_id" {
  description = "The access key ID of the RAM user"
  value       = alicloud_ram_access_key.ramak.id
  sensitive   = true
}

output "this_ram_access_key_secret" {
  description = "The access key secret of the RAM user"
  value       = alicloud_ram_access_key.ramak.secret
  sensitive   = true
}

output "this_sls_project_name" {
  description = "The name of the SLS project"
  value       = alicloud_log_project.sls_project.project_name
}

output "this_sls_logstore_name" {
  description = "The name of the SLS log store"
  value       = alicloud_log_store.sls_log_store.logstore_name
}

output "this_log_machine_group_name" {
  description = "The name of the log machine group"
  value       = alicloud_log_machine_group.machine_group.name
}

output "this_ecs_login_address" {
  description = "The ECS login address for viewing generated logs. Use command: tail -f /tmp/sls-monitor-test.log"
  value       = format("https://ecs-workbench.aliyun.com/?from=ecs&instanceType=ecs&regionId=%s&instanceId=%s&resourceGroupId=", data.alicloud_regions.current.regions[0].id, alicloud_instance.ecs_instance[0].id)
}

output "this_sls_logsearch_url" {
  description = "The SLS log search URL"
  value       = format("https://sls.console.aliyun.com/lognext/project/%s/logsearch/%s?slsRegion=%s", alicloud_log_project.sls_project.project_name, alicloud_log_store.sls_log_store.logstore_name, data.alicloud_regions.current.regions[0].id)
}

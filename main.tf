# Get current region and account information
data "alicloud_regions" "current" {
  current = true
}

# Local variables for complex logic
locals {
  # Default ECS command script for log monitoring setup
  default_ecs_command_script = <<-EOF
    #!/bin/bash
    cat << EOT >> ~/.bash_profile
    export ROS_DEPLOY=true
    export ALIBABA_CLOUD_ACCESS_KEY_ID=${alicloud_ram_access_key.ramak.id}
    export ALIBABA_CLOUD_ACCESS_KEY_SECRET=${alicloud_ram_access_key.ramak.secret}
    EOT

    source ~/.bash_profile
    sleep 60
    # Install loongcollector
    wget http://aliyun-observability-release-${data.alicloud_regions.current.regions[0].id}.oss-${data.alicloud_regions.current.regions[0].id}.aliyuncs.com/loongcollector/linux64/latest/loongcollector.sh -O loongcollector.sh
    chmod +x loongcollector.sh
    ./loongcollector.sh install ${data.alicloud_regions.current.regions[0].id}-internet
    # Generate log
    curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/tech-solution/install-log-monitoring-alarming-0.1.sh|bash
  EOF
}

# VPC resource
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# VSwitch resource
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Security Group resource
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
}

# Security Group Rules resource
resource "alicloud_security_group_rule" "this" {
  for_each = {
    for idx, rule in var.security_group_rules :
    "${rule.type}-${rule.ip_protocol}-${rule.port_range}" => rule
  }

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
}

# RAM User resource
resource "alicloud_ram_user" "ram_user" {
  name = var.ram_user_config.name
}

# RAM Access Key resource
resource "alicloud_ram_access_key" "ramak" {
  user_name = alicloud_ram_user.ram_user.name
}

# RAM User Policy Attachment resource
resource "alicloud_ram_user_policy_attachment" "attach_policy_to_user" {
  user_name   = alicloud_ram_user.ram_user.name
  policy_type = var.ram_policy_attachment_config.policy_type
  policy_name = var.ram_policy_attachment_config.policy_name
}

# ECS Instance resources
resource "alicloud_instance" "ecs_instance" {
  count = var.instance_config.instance_count

  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  system_disk_category       = var.instance_config.system_disk_category
  security_groups            = [alicloud_security_group.security_group.id]
  vswitch_id                 = alicloud_vswitch.vswitch.id
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
}

# ECS Command resource
resource "alicloud_ecs_command" "run_command" {
  name            = var.ecs_command_config.name
  command_content = base64encode(var.custom_ecs_command_script != null ? var.custom_ecs_command_script : local.default_ecs_command_script)
  working_dir     = var.ecs_command_config.working_dir
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
}

# ECS Invocation resource
resource "alicloud_ecs_invocation" "invoke_script" {
  instance_id = alicloud_instance.ecs_instance[*].id
  command_id  = alicloud_ecs_command.run_command.id
  timeouts {
    create = var.ecs_invocation_config.create_timeout
  }
}

# SLS Project resource
resource "alicloud_log_project" "sls_project" {
  project_name = var.log_project_config.project_name
}

# SLS Log Store resource
resource "alicloud_log_store" "sls_log_store" {
  logstore_name = var.log_store_config.logstore_name
  project_name  = alicloud_log_project.sls_project.project_name
}

# SLS Machine Group resource
resource "alicloud_log_machine_group" "machine_group" {
  identify_list = alicloud_instance.ecs_instance[*].primary_ip_address
  name          = var.log_machine_group_config.name
  project       = alicloud_log_project.sls_project.project_name
  identify_type = var.log_machine_group_config.identify_type
}

# Logtail Config resource
resource "alicloud_logtail_config" "logtail_config" {
  project      = alicloud_log_project.sls_project.project_name
  input_detail = var.logtail_config.input_detail
  input_type   = var.logtail_config.input_type
  logstore     = alicloud_log_store.sls_log_store.logstore_name
  name         = var.logtail_config.name
  output_type  = var.logtail_config.output_type
}

# Logtail Attachment resource
resource "alicloud_logtail_attachment" "logtail_attachment" {
  project             = alicloud_log_project.sls_project.project_name
  logtail_config_name = alicloud_logtail_config.logtail_config.name
  machine_group_name  = alicloud_log_machine_group.machine_group.name
}

# SLS Log Store Index resource
resource "alicloud_log_store_index" "sls_index" {
  project  = alicloud_log_project.sls_project.project_name
  logstore = alicloud_log_store.sls_log_store.logstore_name
  full_text {
    token = var.log_store_index_config.full_text_token
  }
  field_search {
    name  = var.log_store_index_config.field_search_name
    type  = var.log_store_index_config.field_search_type
    token = var.log_store_index_config.field_search_token
  }
}
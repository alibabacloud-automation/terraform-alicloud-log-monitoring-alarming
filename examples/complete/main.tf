provider "alicloud" {
  region = var.region
}

# Data sources for getting available resources
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

# Call the log monitoring alarming module
module "log_monitoring_alarming" {
  source = "../../"

  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = var.vpc_name
  }

  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = var.vswitch_name
  }

  security_group_config = {
    security_group_name = var.security_group_name
  }

  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 1
      cidr_ip     = var.vswitch_cidr_block
    }
  ]

  ram_user_config = {
    name = var.ram_user_name
  }

  ram_policy_attachment_config = {
    policy_type = "System"
    policy_name = "AliyunLogFullAccess"
  }

  instance_config = {
    instance_count             = var.instance_count
    instance_name              = var.instance_name
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_type
    system_disk_category       = "cloud_essd"
    password                   = var.ecs_instance_password
    internet_max_bandwidth_out = 5
  }

  ecs_command_config = {
    name        = var.ecs_command_name
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }

  ecs_invocation_config = {
    create_timeout = "15m"
  }

  log_project_config = {
    project_name = var.sls_project_name
  }

  log_store_config = {
    logstore_name = var.sls_logstore_name
  }

  log_machine_group_config = {
    name          = var.log_machine_group_name
    identify_type = "ip"
  }

  logtail_config = {
    name = var.logtail_config_name
    input_detail = jsonencode({
      discardUnmatch = false
      enableRawLog   = true
      fileEncoding   = "utf8"
      filePattern    = "sls-monitor-test.log"
      logPath        = "/tmp"
      logType        = "common_reg_log"
      maxDepth       = 10
      topicFormat    = "none"
    })
    input_type  = "file"
    output_type = "LogService"
  }

  log_store_index_config = {
    full_text_token    = " :#$^*\\r\\n\\t"
    field_search_name  = "content"
    field_search_type  = "text"
    field_search_token = " :#$^*\\r\\n\\t"
  }
}
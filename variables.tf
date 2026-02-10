variable "vpc_config" {
  description = "The parameters of VPC. The attribute 'cidr_block' is required."
  type = object({
    cidr_block = string
    vpc_name   = optional(string, "log-monitoring-vpc")
  })
  default = {
    cidr_block = null
  }
}

variable "vswitch_config" {
  description = "The parameters of VSwitch. The attributes 'cidr_block' and 'zone_id' are required."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "log-monitoring-vswitch")
  })
  default = {
    cidr_block = null
    zone_id    = null
  }
}

variable "security_group_config" {
  description = "The parameters of Security Group."
  type = object({
    security_group_name = optional(string, "log-monitoring-sg")
  })
  default = {}
}

variable "security_group_rules" {
  description = "List of security group rules to create."
  type = list(object({
    type        = string
    ip_protocol = string
    nic_type    = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  }))
  default = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 1
      cidr_ip     = "192.168.0.0/24"
    }
  ]
}

variable "ram_user_config" {
  description = "The parameters of RAM User. The attribute 'name' is required."
  type = object({
    name = string
  })
  default = {
    name = null
  }
}

variable "ram_policy_attachment_config" {
  description = "The parameters of RAM User Policy Attachment."
  type = object({
    policy_type = optional(string, "System")
    policy_name = optional(string, "AliyunLogFullAccess")
  })
  default = {}
}

variable "instance_config" {
  description = "The parameters of ECS Instance. The attributes 'image_id', 'instance_type', and 'password' are required."
  type = object({
    instance_count             = optional(number, 2)
    instance_name              = optional(string, "log-monitoring-ecs")
    image_id                   = string
    instance_type              = string
    system_disk_category       = optional(string, "cloud_essd")
    password                   = string
    internet_max_bandwidth_out = optional(number, 5)
  })
  default = {
    image_id      = null
    instance_type = null
    password      = null
  }
  sensitive = true
}

variable "ecs_command_config" {
  description = "The parameters of ECS Command."
  type = object({
    name        = optional(string, "log-monitoring-command")
    working_dir = optional(string, "/root")
    type        = optional(string, "RunShellScript")
    timeout     = optional(number, 3600)
  })
  default = {}
}

variable "custom_ecs_command_script" {
  description = "Custom ECS command script for log monitoring setup. If not provided, the default script will be used."
  type        = string
  default     = null
}

variable "ecs_invocation_config" {
  description = "The parameters of ECS Invocation."
  type = object({
    create_timeout = optional(string, "15m")
  })
  default = {}
}

variable "log_project_config" {
  description = "The parameters of SLS Project. The attribute 'project_name' is required."
  type = object({
    project_name = string
  })
  default = {
    project_name = null
  }
}

variable "log_store_config" {
  description = "The parameters of SLS Log Store. The attribute 'logstore_name' is required."
  type = object({
    logstore_name = string
  })
  default = {
    logstore_name = null
  }
}

variable "log_machine_group_config" {
  description = "The parameters of SLS Machine Group. The attribute 'name' is required."
  type = object({
    name          = string
    identify_type = optional(string, "ip")
  })
  default = {
    name = null
  }
}

variable "logtail_config" {
  description = "The parameters of Logtail Config. The attributes 'name', 'input_detail', 'input_type', and 'output_type' are required."
  type = object({
    name         = string
    input_detail = string
    input_type   = string
    output_type  = string
  })
  default = {
    name         = null
    input_detail = null
    input_type   = null
    output_type  = null
  }
}

variable "log_store_index_config" {
  description = "The parameters of SLS Log Store Index."
  type = object({
    full_text_token    = optional(string, " :#$^*\\r\\n\\t")
    field_search_name  = optional(string, "content")
    field_search_type  = optional(string, "text")
    field_search_token = optional(string, " :#$^*\\r\\n\\t")
  })
  default = {}
}
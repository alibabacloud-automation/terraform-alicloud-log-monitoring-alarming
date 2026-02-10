阿里云日志监控告警 Terraform 模块

# terraform-alicloud-log-monitoring-alarming

[English](https://github.com/alibabacloud-automation/terraform-alicloud-log-monitoring-alarming/blob/main/README.md) | 简体中文

该 Terraform 模块在阿里云上创建一个全面的日志监控和告警解决方案。它实现了[构建面向应用日志的实时监控](https://www.aliyun.com/solution/tech-solution/log-monitoring-alarming)解决方案，涉及专有网络（VPC）、交换机（VSwitch）、云服务器（ECS）、SLS（简单日志服务）和 RAM 用户等资源的创建和部署，以提供实时应用日志监控能力。

## 使用方法

该模块提供了设置日志监控和告警基础设施的完整解决方案。它创建 VPC 网络资源、用于日志生成的 ECS 实例、用于日志收集和存储的 SLS 组件，以及必要的 RAM 权限。

```terraform
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = "ecs.e-c1m2.large"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

module "log_monitoring_alarming" {
  source = "alibabacloud-automation/log-monitoring-alarming/alicloud"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "log-monitoring-vpc"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = "log-monitoring-vswitch"
  }

  ram_user_config = {
    name = "log-monitoring-ram-user"
  }

  instance_config = {
    instance_count             = 2
    instance_name              = "log-monitoring-ecs"
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = "ecs.e-c1m2.large"
    password                   = "YourPassword123!"
    internet_max_bandwidth_out = 5
  }

  log_project_config = {
    project_name = "log-monitoring-project"
  }

  log_store_config = {
    logstore_name = "log-monitoring-logstore"
  }

  log_machine_group_config = {
    name = "log-monitoring-machine-group"
  }

  logtail_config = {
    name         = "log-monitoring-logtail-config"
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
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-log-monitoring-alarming/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.run_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_log_machine_group.machine_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_machine_group) | resource |
| [alicloud_log_project.sls_project](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_project) | resource |
| [alicloud_log_store.sls_log_store](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_store) | resource |
| [alicloud_log_store_index.sls_index](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_store_index) | resource |
| [alicloud_logtail_attachment.logtail_attachment](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/logtail_attachment) | resource |
| [alicloud_logtail_config.logtail_config](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/logtail_config) | resource |
| [alicloud_ram_access_key.ramak](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_access_key) | resource |
| [alicloud_ram_user.ram_user](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user) | resource |
| [alicloud_ram_user_policy_attachment.attach_policy_to_user](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user_policy_attachment) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_ecs_command_script"></a> [custom\_ecs\_command\_script](#input\_custom\_ecs\_command\_script) | Custom ECS command script for log monitoring setup. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | The parameters of ECS Command. | <pre>object({<br/>    name        = optional(string, "log-monitoring-command")<br/>    working_dir = optional(string, "/root")<br/>    type        = optional(string, "RunShellScript")<br/>    timeout     = optional(number, 3600)<br/>  })</pre> | `{}` | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | The parameters of ECS Invocation. | <pre>object({<br/>    create_timeout = optional(string, "15m")<br/>  })</pre> | `{}` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | The parameters of ECS Instance. The attributes 'image\_id', 'instance\_type', and 'password' are required. | <pre>object({<br/>    instance_count             = optional(number, 2)<br/>    instance_name              = optional(string, "log-monitoring-ecs")<br/>    image_id                   = string<br/>    instance_type              = string<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    password                   = string<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": null,<br/>  "password": null<br/>}</pre> | no |
| <a name="input_log_machine_group_config"></a> [log\_machine\_group\_config](#input\_log\_machine\_group\_config) | The parameters of SLS Machine Group. The attribute 'name' is required. | <pre>object({<br/>    name          = string<br/>    identify_type = optional(string, "ip")<br/>  })</pre> | <pre>{<br/>  "name": null<br/>}</pre> | no |
| <a name="input_log_project_config"></a> [log\_project\_config](#input\_log\_project\_config) | The parameters of SLS Project. The attribute 'project\_name' is required. | <pre>object({<br/>    project_name = string<br/>  })</pre> | <pre>{<br/>  "project_name": null<br/>}</pre> | no |
| <a name="input_log_store_config"></a> [log\_store\_config](#input\_log\_store\_config) | The parameters of SLS Log Store. The attribute 'logstore\_name' is required. | <pre>object({<br/>    logstore_name = string<br/>  })</pre> | <pre>{<br/>  "logstore_name": null<br/>}</pre> | no |
| <a name="input_log_store_index_config"></a> [log\_store\_index\_config](#input\_log\_store\_index\_config) | The parameters of SLS Log Store Index. | <pre>object({<br/>    full_text_token    = optional(string, " :#$^*\\r\\n\\t")<br/>    field_search_name  = optional(string, "content")<br/>    field_search_type  = optional(string, "text")<br/>    field_search_token = optional(string, " :#$^*\\r\\n\\t")<br/>  })</pre> | `{}` | no |
| <a name="input_logtail_config"></a> [logtail\_config](#input\_logtail\_config) | The parameters of Logtail Config. The attributes 'name', 'input\_detail', 'input\_type', and 'output\_type' are required. | <pre>object({<br/>    name         = string<br/>    input_detail = string<br/>    input_type   = string<br/>    output_type  = string<br/>  })</pre> | <pre>{<br/>  "input_detail": null,<br/>  "input_type": null,<br/>  "name": null,<br/>  "output_type": null<br/>}</pre> | no |
| <a name="input_ram_policy_attachment_config"></a> [ram\_policy\_attachment\_config](#input\_ram\_policy\_attachment\_config) | The parameters of RAM User Policy Attachment. | <pre>object({<br/>    policy_type = optional(string, "System")<br/>    policy_name = optional(string, "AliyunLogFullAccess")<br/>  })</pre> | `{}` | no |
| <a name="input_ram_user_config"></a> [ram\_user\_config](#input\_ram\_user\_config) | The parameters of RAM User. The attribute 'name' is required. | <pre>object({<br/>    name = string<br/>  })</pre> | <pre>{<br/>  "name": null<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | The parameters of Security Group. | <pre>object({<br/>    security_group_name = optional(string, "log-monitoring-sg")<br/>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group rules to create. | <pre>list(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    nic_type    = string<br/>    policy      = string<br/>    port_range  = string<br/>    priority    = number<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_ip": "192.168.0.0/24",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "22/22",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  }<br/>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    cidr_block = string<br/>    vpc_name   = optional(string, "log-monitoring-vpc")<br/>  })</pre> | <pre>{<br/>  "cidr_block": null<br/>}</pre> | no |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | The parameters of VSwitch. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, "log-monitoring-vswitch")<br/>  })</pre> | <pre>{<br/>  "cidr_block": null,<br/>  "zone_id": null<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ecs_instance_ids"></a> [this\_ecs\_instance\_ids](#output\_this\_ecs\_instance\_ids) | The IDs of the ECS instances |
| <a name="output_this_ecs_instance_private_ips"></a> [this\_ecs\_instance\_private\_ips](#output\_this\_ecs\_instance\_private\_ips) | The private IP addresses of the ECS instances |
| <a name="output_this_ecs_instance_public_ips"></a> [this\_ecs\_instance\_public\_ips](#output\_this\_ecs\_instance\_public\_ips) | The public IP addresses of the ECS instances |
| <a name="output_this_ecs_login_address"></a> [this\_ecs\_login\_address](#output\_this\_ecs\_login\_address) | The ECS login address for viewing generated logs. Use command: tail -f /tmp/sls-monitor-test.log |
| <a name="output_this_log_machine_group_name"></a> [this\_log\_machine\_group\_name](#output\_this\_log\_machine\_group\_name) | The name of the log machine group |
| <a name="output_this_ram_access_key_id"></a> [this\_ram\_access\_key\_id](#output\_this\_ram\_access\_key\_id) | The access key ID of the RAM user |
| <a name="output_this_ram_access_key_secret"></a> [this\_ram\_access\_key\_secret](#output\_this\_ram\_access\_key\_secret) | The access key secret of the RAM user |
| <a name="output_this_ram_user_name"></a> [this\_ram\_user\_name](#output\_this\_ram\_user\_name) | The name of the RAM user |
| <a name="output_this_security_group_id"></a> [this\_security\_group\_id](#output\_this\_security\_group\_id) | The ID of the Security Group |
| <a name="output_this_sls_logsearch_url"></a> [this\_sls\_logsearch\_url](#output\_this\_sls\_logsearch\_url) | The SLS log search URL |
| <a name="output_this_sls_logstore_name"></a> [this\_sls\_logstore\_name](#output\_this\_sls\_logstore\_name) | The name of the SLS log store |
| <a name="output_this_sls_project_name"></a> [this\_sls\_project\_name](#output\_this\_sls\_project\_name) | The name of the SLS project |
| <a name="output_this_vpc_cidr_block"></a> [this\_vpc\_cidr\_block](#output\_this\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_this_vpc_id"></a> [this\_vpc\_id](#output\_this\_vpc\_id) | The ID of the VPC |
| <a name="output_this_vswitch_cidr_block"></a> [this\_vswitch\_cidr\_block](#output\_this\_vswitch\_cidr\_block) | The CIDR block of the VSwitch |
| <a name="output_this_vswitch_id"></a> [this\_vswitch\_id](#output\_this\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
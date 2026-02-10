variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "cn-shenzhen"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "log-monitoring-vpc-example"
}

variable "vswitch_cidr_block" {
  description = "The CIDR block for the VSwitch"
  type        = string
  default     = "192.168.0.0/24"
}

variable "vswitch_name" {
  description = "The name of the VSwitch"
  type        = string
  default     = "log-monitoring-vswitch-example"
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "log-monitoring-sg-example"
}

variable "ram_user_name" {
  description = "The name of the RAM user"
  type        = string
  default     = "log-monitoring-ram-user-example"
}

variable "instance_count" {
  description = "The number of ECS instances to create"
  type        = number
  default     = 2
}

variable "instance_name" {
  description = "The name of the ECS instances"
  type        = string
  default     = "log-monitoring-ecs-example"
}

variable "instance_type" {
  description = "The type of ECS instances"
  type        = string
  default     = "ecs.e-c1m2.large"
}

variable "ecs_instance_password" {
  description = "The password for ECS instances. Must be 8-30 characters and contain at least three of the following: uppercase letters, lowercase letters, numbers, and special characters"
  type        = string
  default     = "Terraform123!"
  sensitive   = true
}

variable "ecs_command_name" {
  description = "The name of the ECS command"
  type        = string
  default     = "log-monitoring-command-example"
}

variable "sls_project_name" {
  description = "The name of the SLS project"
  type        = string
  default     = "log-monitoring-project-example"
}

variable "sls_logstore_name" {
  description = "The name of the SLS log store"
  type        = string
  default     = "log-monitoring-logstore-example"
}

variable "log_machine_group_name" {
  description = "The name of the log machine group"
  type        = string
  default     = "log-monitoring-machine-group-example"
}

variable "logtail_config_name" {
  description = "The name of the logtail config"
  type        = string
  default     = "log-monitoring-logtail-config-example"
}
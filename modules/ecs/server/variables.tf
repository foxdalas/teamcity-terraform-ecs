variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
  default     = ""
}

variable "service_role_arn" {
  description = "Service role ARN"
  type        = string
  default     = ""
}

variable "efs_filesystem_id" {
  description = "EFS Filesystem ID"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "jetbrains/teamcity-server:latest"
}

variable "container_cpu" {
  description = "Container cpu"
  type        = number
  default     = 2048
}

variable "container_memory" {
  description = "Container memory"
  type        = number
  default     = 3584
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8111
}

variable "host_port" {
  description = "Host port"
  type        = number
  default     = 8111
}

variable "efs_filesystem_mount_path" {
  description = "Container mEFS mount path"
  type        = string
  default     = ""
}

variable "database_config" {
  description = "database.properties file"
  type        = string
  default     = ""
}

variable "capacity_provider" {
  description = "Capacity Provider"
  type        = string
  default     = ""
}

variable "lb_target_group" {
  description = "LoadBalancer Target Group"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = ""
}

variable "log_retention" {
  description = "Log retention (days)"
  default     = 1
  type        = number
}

variable "data_volume_name" {
  description = "Data Volume name"
  default     = "data-volume"
  type        = string
}

variable "data_volume_path" {
  description = "Data Volume path"
  default     = "/data"
  type        = string
}

variable "cache_volume_name" {
  description = "Cache Volume name"
  default     = "cache-volume"
  type        = string
}

variable "cache_volume_path" {
  description = "Cache Volume path"
  default     = "/caches"
  type        = string
}

variable "mem_opts" {
  description = "TEAMCITY_SERVER_MEM_OPTS"
  default     = "-Xmx3g -XX:ReservedCodeCacheSize=350m"
  type        = string
}

variable "plugins_list" {
  description = "TeamCity Server Plugins list"
  type        = string
  default     = "[{\\\"name\\\":\\\"aws-ecs\\\",\\\"url\\\":\\\"https://plugins.jetbrains.com/files/10067/76713/aws-ecs.zip\\\"}]"
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647"
  type        = number
  default     = 120
}

locals {
  name          = var.name
  log_retention = var.log_retention

  cluster_name              = var.cluster_name
  service_role_arn          = var.service_role_arn
  task_role_arn             = var.task_role_arn
  efs_filesystem_id         = var.efs_filesystem_id
  efs_filesystem_mount_path = var.efs_filesystem_mount_path

  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_cpu

  container_port = var.container_port
  host_port      = var.host_port

  database_config = var.database_config

  data_volume_name = var.data_volume_name
  data_volume_path = var.data_volume_path

  cache_volume_name = var.cache_volume_name
  cache_volume_path = var.cache_volume_path

  mem_opts = var.mem_opts

  capacity_provider = var.capacity_provider
  lb_target_group   = var.lb_target_group

  health_check_grace_period_seconds = var.health_check_grace_period_seconds


  plugins_list = var.plugins_list

  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

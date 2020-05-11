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
  default     = 3072
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

locals {
  name          = var.name
  log_retention = var.log_retention

  cluster_name              = var.cluster_name
  task_role_arn             = var.task_role_arn
  efs_filesystem_id         = var.efs_filesystem_id
  efs_filesystem_mount_path = var.efs_filesystem_mount_path

  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_cpu

  database_config = var.database_config

  capacity_provider = var.capacity_provider
  lb_target_group   = var.lb_target_group

  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

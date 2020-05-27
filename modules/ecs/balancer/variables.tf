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

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "foxdalas/tc-haproxy:latest"
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

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647"
  type        = number
  default     = 120
}

locals {
  name          = var.name
  log_retention = var.log_retention

  cluster_name     = var.cluster_name
  service_role_arn = var.service_role_arn
  task_role_arn    = var.task_role_arn

  container_image = var.container_image

  capacity_provider = var.capacity_provider
  lb_target_group   = var.lb_target_group

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

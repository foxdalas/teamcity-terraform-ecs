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

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "jetbrains/teamcity-agent:latest"
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

variable "capacity_provider" {
  description = "Capacity Provider"
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

  task_role_arn = var.task_role_arn

  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_cpu


  capacity_provider = var.capacity_provider

  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

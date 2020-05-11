variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_id" {}

variable "port" {
  description = "EFS Port"
  type        = number
  default     = "2049"
}

variable "subnets_ids" {
  description = "List of VPC subnet IDs used to deploy EFS"
  type        = list
  default     = []
}

variable "trusted_cidr_blocks" {
  description = "Trusted subnets for efs mount."
  type        = list(string)
  default     = [""]
}

variable "performance_mode" {
  description = "Default EFS Performance mode"
  default     = "maxIO"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

locals {
  name                = var.name
  vpc_id              = var.vpc_id
  port                = var.port
  subnets_ids         = var.subnets_ids
  trusted_cidr_blocks = var.trusted_cidr_blocks
  performance_mode    = var.performance_mode
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

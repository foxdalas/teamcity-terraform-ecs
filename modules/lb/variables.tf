variable "vpc_id" {
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = ""
  type        = list(string)
  default     = []
}

variable "internal" {
  description = "State whether the ELB is internal or public facing"
  type        = bool
  default     = false
}

variable "int_web_port" {
  description = "ELB port assigned for internal WEB communication"
  type        = string
  default     = ""
}

variable "target_cidr_blocks" {
  description = "AWS private target subnet CIDR"
  type        = list(string)
  default     = []
}


variable "ext_web_port" {
  description = "ELB port assigned for external WEB communication"
  type        = string
  default     = ""
}

variable "health_check_path" {
  description = "Target group health check path"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Target group health check port"
  type        = number
  default     = "80"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


locals {
  vpc_id             = var.vpc_id
  name               = var.name
  public_subnets     = var.public_subnets
  internal           = var.internal
  target_cidr_blocks = var.target_cidr_blocks
  int_web_port       = var.int_web_port
  ext_web_port       = var.ext_web_port
  health_check_path  = var.health_check_path
  health_check_port  = var.health_check_port
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}


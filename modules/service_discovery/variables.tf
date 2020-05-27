variable "vpc_id" {}

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

locals {
  name   = var.name
  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

variable "vpc_id" {}

variable "name" {
  description = "RDS Name"
  default     = "teamcity"
  type        = string
}

variable "allocated_storage" {
  description = "RDS Allocated storage"
  default     = "20"
  type        = number
}

variable "storage_type" {
  description = "RDS Strage type"
  default     = "gp2"
  type        = string
}

variable "engine" {
  description = "RDS Engine"
  default     = "mysql"
  type        = string
}

variable "engine_version" {
  description = "RDS Engine version"
  default     = "5.7"
  type        = string
}

variable "instance_class" {
  description = "RDS Instance class"
  default     = "db.t3.micro"
  type        = string
}

variable "database" {
  description = "RDS Database name"
  type        = string
}

variable "username" {
  description = "RDS Usernames"
  type        = string
}

variable "password" {
  description = "RDS Password"
  type        = string
}

variable "parameter_group_name" {
  description = "RDS Parameter group name"
  default     = "default.mysql5.7"
  type        = string
}

variable "db_subnets" {
  description = "RDS DB Subnets"
  type        = list(string)
}

variable "trusted_cidr_blocks" {
  description = "Trusted subnets for rds connection."
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


locals {
  vpc_id               = var.vpc_id
  name                 = var.name
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  database             = var.database
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  instance_class       = var.instance_class
  db_subnets           = var.db_subnets
  trusted_cidr_blocks  = var.trusted_cidr_blocks
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}


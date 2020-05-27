variable "project_name" {
  description = "Project name"
  default     = "teamcity"
  type        = string
}

variable "environment" {
  description = "Project environment (example, staging, production, etc)"
  default     = "example"
  type        = string
}

variable "log_retention" {
  description = "Log retention (days)"
  default     = 1
  type        = number
}

variable "vpc_cidr" {
  description = "VPC Network CIDR"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_azs" {
  description = "VPC Availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "VPC Private Subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  type        = list(string)
}

variable "ecs_asg_min_size" {
  description = "ECS ASG Minimal size"
  default     = 0
  type        = number
}

variable "ecs_asg_max_size" {
  description = "ECS ASG Maximal size"
  default     = 5
  type        = number
}

variable "server_container_image" {
  description = "TeamCity Server Container image"
  default     = "jetbrains/teamcity-server:latest"
  type        = string
}

variable "server_container_cpu" {
  description = "TeamCity Server Request CPU"
  default     = "2048"
  type        = number
}

variable "server_container_memory" {
  description = "TeamCity Server Request Memory"
  default     = "3584"
  type        = number
}

variable "server_database_name" {
  description = "TeamCity Server Database name"
  default     = "teamcity"
  type        = string
}

variable "server_database_username" {
  description = "TeamCity Server Database username"
  default     = "teamcity"
  type        = string
}

variable "server_database_password" {
  description = "TeamCity Server Database password"
  default     = "ree3au4aag8ionguas7xai3d"
  type        = string
}

variable "server_container_data_dir" {
  description = "TeamCity Data Directory is the directory on the file system used by TeamCity server to store configuration settings, build results and current operation files"
  default     = "/data"
  type        = string
}

variable "agent_container_image" {
  description = "TeamCity Agent Container image"
  default     = "jetbrains/teamcity-agent:latest"
  type        = string
}

variable "agent_container_cpu" {
  description = "TeamCity Agent Request CPU"
  default     = "2048"
  type        = number
}

variable "agent_container_memory" {
  description = "TeamCity Agent Request Memory"
  default     = "3072"
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

locals {
  name = "${var.project_name}-${var.environment}"

  project_name  = var.project_name
  environment   = var.environment
  log_retention = var.log_retention

  vpc_cidr = var.vpc_cidr
  vpc_azs  = var.vpc_azs

  vpc_public_subnets  = var.vpc_public_subnets
  vpc_private_subnets = var.vpc_private_subnets

  ecs_asg_min_size = var.ecs_asg_min_size
  ecs_asg_max_size = var.ecs_asg_max_size

  server_container_image    = var.server_container_image
  server_container_cpu      = var.server_container_cpu
  server_container_memory   = var.server_container_memory
  server_container_data_dir = var.server_container_data_dir

  server_database_name     = var.server_database_name
  server_database_username = var.server_database_username
  server_database_password = var.server_database_password

  agent_container_image  = var.agent_container_image
  agent_container_cpu    = var.agent_container_cpu
  agent_container_memory = var.agent_container_memory

  #server_database_config = "connectionUrl=jdbc:hsqldb:file:${var.server_container_data_dir}/buildserver"
  server_database_config = "connectionUrl=jdbc:mysql://#{db_address}:3306/#{db_name}\nconnectionProperties.user=#{db_username}\nconnectionProperties.password=#{db_password}\nmaxConnections=50\ntestOnBorrow=true"

  tags = merge(
    {
      "Project"     = format("%s", local.project_name),
      "Environment" = format("%s", local.environment),
      "Terraform"   = "true"
    },
    var.tags
  )
}

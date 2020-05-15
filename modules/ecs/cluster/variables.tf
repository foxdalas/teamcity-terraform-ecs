variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = ""
}

variable "vpc_id" {
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "ECS node instance type. "
  type        = string
  default     = "t3.medium"
}

variable "trusted_cidr_blocks" {
  description = "Trusted subnets e.g. with ALB and bastion host."
  type        = list(string)
  default     = [""]
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

variable "security_group_ids" {
  description = "Additional security group IDs. Default security group would be merged with the provided list."
  default     = []
}

variable "subnets_ids" {
  description = "IDs of subnets. Use subnets from various availability zones to make the cluster more reliable."
}

variable "target_capacity" {
  description = "The target utilization for the cluster. A number between 1 and 100."
  default     = "100"
  type        = number
}

variable "asg_min_size" {
  description = "ECS EC2 Nodes ASG Minimal size"
  default     = 0
  type        = number
}

variable "asg_max_size" {
  description = "ECS EC2 Nodes ASG Maximal size"
  default     = 3
  type        = number
}

variable "key_name" {
  description = "EC2 Key pair name"
  type        = string
  default     = null
}

locals {
  name                = var.name
  cluster_name        = var.cluster_name
  vpc_id              = var.vpc_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  trusted_cidr_blocks = var.trusted_cidr_blocks
  subnets_ids         = var.subnets_ids
  sg_ids              = distinct(concat(var.security_group_ids, [aws_security_group.ecs_nodes.id]))
  target_capacity     = var.target_capacity
  ami_id              = data.aws_ssm_parameter.ecs_ami.value
  asg_min_size        = var.asg_min_size
  asg_max_size        = var.asg_max_size
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

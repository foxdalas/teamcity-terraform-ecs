variable "vpc_id" {
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "ssh_allow_subnets" {
  description = "List of subnets and/or IPs that can access the bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "subnet_id" {
  description = "Subnet ID to launch Bastion in"
}

variable "disk_size" {
  description = "Bastion root disk size"
  type        = number
  default     = "10"
}

variable "key_name" {
  description = "Bastion SSH key pair name"
  default     = ""
}

variable "instance_type" {
  description = "Bastion instance type"
  default     = "t3.micro"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

data "aws_ssm_parameter" "bastion_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id"
}

locals {
  vpc_id        = var.vpc_id
  name          = var.name
  ami_id        = data.aws_ssm_parameter.bastion_ami.value
  disk_size     = var.disk_size
  key_name      = var.key_name
  instance_type = var.instance_type
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    var.tags
  )
}

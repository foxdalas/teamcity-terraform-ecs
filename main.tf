provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = "~> 2.61.0"
  }
}

resource "aws_key_pair" "main" {
  key_name   = local.name
  public_key = file("~/.ssh/id_rsa.pub")

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.33.0"

  name            = local.name
  cidr            = local.vpc_cidr
  azs             = local.vpc_azs
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  enable_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags
}

module "bastion" {
  source = "./modules/bastion"

  name = "${local.name}-bastion"

  vpc_id    = module.vpc.vpc_id
  key_name  = aws_key_pair.main.key_name
  subnet_id = module.vpc.public_subnets.0

  tags = local.tags
}

module "efs" {
  source = "./modules/efs"

  name                = "${local.name}-efs"
  vpc_id              = module.vpc.vpc_id
  subnets_ids         = module.vpc.private_subnets
  trusted_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  tags = local.tags
}


module "rds" {
  source = "./modules/rds"

  name                = "${local.name}-rds"
  vpc_id              = module.vpc.vpc_id
  db_subnets          = module.vpc.private_subnets
  trusted_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  database = local.server_database_name
  username = local.server_database_username
  password = local.server_database_password
}

module "service_discovery" {
  source = "./modules/service_discovery"

  name   = "${local.name}-sd"
  vpc_id = module.vpc.vpc_id

  tags = local.tags
}

module "alb" {
  source = "./modules/lb"

  name   = "${local.name}-lb"
  vpc_id = module.vpc.vpc_id

  public_subnets     = module.vpc.public_subnets
  target_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  int_web_port       = 8080
  ext_web_port       = 80
  health_check_path  = "/healthz"
  health_check_port  = 8081

  tags = local.tags
}

module "ecs" {
  source = "./modules/ecs/cluster"

  name         = "${local.name}-ecs"
  vpc_id       = module.vpc.vpc_id
  cluster_name = local.name

  asg_min_size = local.ecs_asg_min_size
  asg_max_size = local.ecs_asg_max_size

  instance_type       = "t3a.medium"
  trusted_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  subnets_ids         = module.vpc.private_subnets
  key_name            = aws_key_pair.main.key_name

  tags = local.tags
}

module "balancer" {
  source = "./modules/ecs/balancer"

  name             = "${local.name}-balancer"
  cluster_name     = local.name
  service_role_arn = module.ecs.ecs_service_role_name
  task_role_arn    = module.ecs.ecs_default_task_role_arn

  capacity_provider = module.ecs.ecs_capacity_provider_name
  lb_target_group   = module.alb.target_group.arn
}


module "server" {
  source = "./modules/ecs/server"

  name             = "${local.name}-master"
  vpc_id           = module.vpc.vpc_id
  cluster_name     = local.name
  service_role_arn = module.ecs.ecs_service_role_name
  task_role_arn    = module.ecs.ecs_default_task_role_arn

  private_subnets = module.vpc.private_subnets

  efs_filesystem_id         = module.efs.filesystem_id
  efs_filesystem_mount_path = local.server_container_data_dir

  container_image  = local.server_container_image
  container_cpu    = local.server_container_cpu
  container_memory = local.server_container_memory

  database_name     = local.server_database_name
  database_username = local.server_database_username
  database_password = local.server_database_password
  database_address  = module.rds.address

  capacity_provider = module.ecs.ecs_capacity_provider_name
  lb_target_group   = module.alb.target_group.arn

  sd_namespace_id = module.service_discovery.namespace_id

  tags = local.tags
}

module "readonly" {
  source = "./modules/ecs/server"

  name             = "${local.name}-readonly"
  vpc_id           = module.vpc.vpc_id
  cluster_name     = local.name
  service_role_arn = module.ecs.ecs_service_role_name
  task_role_arn    = module.ecs.ecs_default_task_role_arn

  private_subnets = module.vpc.private_subnets

  server_opts = "-Dteamcity.server.nodeId=readonly -Dteamcity.server.rootURL=http://${module.server.master_server_address}"

  efs_filesystem_id         = module.efs.filesystem_id
  efs_filesystem_mount_path = local.server_container_data_dir

  container_image  = local.server_container_image
  container_cpu    = local.server_container_cpu
  container_memory = local.server_container_memory

  database_name     = local.server_database_name
  database_username = local.server_database_username
  database_password = local.server_database_password
  database_address  = module.rds.address

  capacity_provider = module.ecs.ecs_capacity_provider_name
  lb_target_group   = module.alb.target_group.arn

  sd_namespace_id = module.service_discovery.namespace_id

  tags = local.tags
}


module "agent" {
  source = "./modules/ecs/agent"

  name          = "${local.name}-agent"
  task_role_arn = module.ecs.ecs_default_task_role_arn

  container_image  = local.agent_container_image
  container_cpu    = local.agent_container_cpu
  container_memory = local.agent_container_memory

  capacity_provider = module.ecs.ecs_capacity_provider_name

  tags = local.tags
}


resource "aws_ecs_service" "server" {
  name    = local.name
  cluster = local.cluster_name

  #iam_role        = module.ecs.ecs_default_task_role_name
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = 1
  }

  load_balancer {
    target_group_arn = local.lb_target_group
    container_name   = local.name
    container_port   = 8111
  }

  depends_on = [
    aws_ecs_task_definition.server
  ]
}

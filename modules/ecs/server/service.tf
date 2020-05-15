resource "aws_ecs_service" "server" {
  name    = local.name
  cluster = local.cluster_name

  iam_role        = local.service_role_arn
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1

  health_check_grace_period_seconds = local.health_check_grace_period_seconds

  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = 1
  }

  load_balancer {
    target_group_arn = local.lb_target_group
    container_name   = local.name
    container_port   = local.container_port
  }

  depends_on = [
    aws_ecs_task_definition.server
  ]
}

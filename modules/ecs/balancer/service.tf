resource "aws_ecs_service" "balancer" {
  name    = local.name
  cluster = local.cluster_name

  task_definition = aws_ecs_task_definition.balancer.arn
  desired_count   = 1

  health_check_grace_period_seconds = local.health_check_grace_period_seconds

  capacity_provider_strategy {
    capacity_provider = local.capacity_provider
    weight            = 1
  }

  load_balancer {
    target_group_arn = local.lb_target_group
    container_name   = local.name
    container_port   = "8080"
  }

  depends_on = [
    aws_ecs_task_definition.balancer
  ]
}

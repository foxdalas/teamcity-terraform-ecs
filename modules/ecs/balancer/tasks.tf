data "aws_region" "current" {}

resource "aws_ecs_task_definition" "balancer" {
  family        = local.name
  task_role_arn = local.task_role_arn

  network_mode = "bridge"

  container_definitions = templatefile("${path.module}/tasks/balancer.tmpl", {
    family = local.name
    name   = local.name
    image  = local.container_image

    #AWSLogs configuration
    region        = data.aws_region.current.name
    stream_prefix = split("-", local.name)[0]
  })


  tags = local.tags
}

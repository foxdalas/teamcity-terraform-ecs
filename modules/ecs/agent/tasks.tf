data "aws_region" "current" {}

resource "aws_ecs_task_definition" "agent" {
  family        = local.name
  task_role_arn = local.task_role_arn

  container_definitions = templatefile("${path.module}/tasks/agent.tmpl", {
    # Container configuration
    name   = local.name
    family = local.name
    image  = local.container_image
    cpu    = local.container_cpu
    memory = local.container_memory

    #AWSLogs configuration
    region        = data.aws_region.current.name
    stream_prefix = split("-", local.name)[0]
  })

  tags = local.tags
}

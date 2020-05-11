data "aws_region" "current" {}

resource "aws_ecs_task_definition" "server" {
  family        = local.name
  task_role_arn = local.task_role_arn

  volume {
    name = "cache-volume"
  }
  volume {
    name = "data-volume"
    efs_volume_configuration {
      file_system_id = local.efs_filesystem_id
      root_directory = "/"
    }
  }

  container_definitions = templatefile("${path.module}/tasks/server.tmpl", {
    # Container configuration
    name            = local.name
    family          = local.name
    image           = local.container_image
    cpu             = local.container_cpu
    memory          = local.container_memory
    volume_name     = "data-volume"
    container_path  = local.efs_filesystem_mount_path
    database_config = local.database_config

    #AWSLogs configuration
    region        = data.aws_region.current.name
    stream_prefix = split("-", local.name)[0]
  })

  tags = local.tags
}

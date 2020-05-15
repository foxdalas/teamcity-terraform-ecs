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
    name             = local.name
    family           = local.name
    image            = local.container_image
    cpu              = local.container_cpu
    memory           = local.container_memory
    container_port   = local.container_port
    host_port        = local.host_port
    data_volume_name = local.data_volume_name
    container_path   = local.efs_filesystem_mount_path
    database_config  = local.database_config

    mem_opts = local.mem_opts

    data_volume_name = local.data_volume_name
    data_volume_path = local.data_volume_path

    cache_volume_name = local.cache_volume_name
    cache_volume_path = local.cache_volume_path

    plugins_list = local.plugins_list



    #AWSLogs configuration
    region        = data.aws_region.current.name
    stream_prefix = split("-", local.name)[0]
  })


  tags = local.tags
}

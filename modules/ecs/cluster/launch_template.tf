resource "aws_launch_template" "node" {
  name_prefix            = "ECS_NODES_"
  image_id               = local.ami_id
  instance_type          = local.instance_type
  vpc_security_group_ids = local.sg_ids
  key_name               = local.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_node.name
  }

  user_data = base64encode(<<EOT
#!/bin/bash
echo ECS_CLUSTER="${local.cluster_name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }

  tags = local.tags
}

resource "aws_autoscaling_group" "ecs_nodes" {
  name_prefix           = "CLUSTER_NODES_"
  max_size              = local.asg_max_size
  min_size              = local.asg_min_size
  vpc_zone_identifier   = local.subnets_ids
  protect_from_scale_in = true

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.node.id
        version            = "$Latest"
      }

      override {
        instance_type     = local.instance_type
        weighted_capacity = 1
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
}

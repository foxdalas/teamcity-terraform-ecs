resource "aws_alb_target_group" "main" {
  name     = "${local.name}-tg"
  port     = local.int_web_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path              = local.health_check_path
    interval          = "5"
    timeout           = "3"
    healthy_threshold = "2"

  }

  tags = local.tags
}
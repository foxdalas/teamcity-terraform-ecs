resource "aws_lb_target_group" "main" {
  name     = "${local.name}-tg"
  port     = local.int_web_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  deregistration_delay = 120

  health_check {
    path              = local.health_check_path
    port              = local.health_check_port
    interval          = "5"
    timeout           = "3"
    healthy_threshold = "2"
    matcher           = "200"

  }

  depends_on = [aws_lb.main]

  tags = local.tags
}

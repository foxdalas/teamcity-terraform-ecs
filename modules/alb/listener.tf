resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.id
  port              = local.ext_web_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

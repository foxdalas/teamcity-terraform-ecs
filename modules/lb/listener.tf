resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.id
  port              = local.ext_web_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.main]
}

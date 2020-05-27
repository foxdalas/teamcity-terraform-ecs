resource "aws_lb" "server" {
  name            = local.name
  internal        = true
  security_groups = [aws_security_group.server.id]
  subnets         = var.private_subnets

  tags = local.tags
}

resource "aws_security_group" "server" {
  name   = "${local.name}-sg"
  vpc_id = local.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "egress" {
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  security_group_id = aws_security_group.server.id
  type              = "egress"
  cidr_blocks       = ["10.0.0.0/8"]
}

#TODO: Add count for ingress
resource "aws_security_group_rule" "ingress" {
  protocol          = "TCP"
  from_port         = 80
  to_port           = 80
  security_group_id = aws_security_group.server.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.server.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.server.id
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.server]
}


resource "aws_lb_target_group" "server" {
  name     = "${local.name}-tg"
  port     = local.container_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  deregistration_delay = 120

  health_check {
    path              = ""
    interval          = "20"
    timeout           = "10"
    healthy_threshold = "2"
    matcher           = "200"
  }

  depends_on = [aws_lb.server]

  tags = local.tags
}


resource "aws_lb" "main" {
  name            = local.name
  internal        = local.internal
  security_groups = [aws_security_group.main.id]
  subnets         = var.public_subnets

  tags = local.tags
}

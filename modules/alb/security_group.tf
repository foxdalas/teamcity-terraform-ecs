resource "aws_security_group" "main" {
  name   = "${local.name}-sg"
  vpc_id = local.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "egress" {
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
  security_group_id = aws_security_group.main.id
  type              = "egress"
  cidr_blocks       = local.target_cidr_blocks
}

#TODO: Add count for ingress
resource "aws_security_group_rule" "ingress" {
  protocol          = "TCP"
  from_port         = local.ext_web_port
  to_port           = local.ext_web_port
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
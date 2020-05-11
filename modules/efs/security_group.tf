resource "aws_security_group" "main" {
  name        = "${local.name}-sg"
  description = "EFS Security Group"
  vpc_id      = local.vpc_id

  # Default EFS Ingress Rule
  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = local.trusted_cidr_blocks
  }

  # Default Egress Rule
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

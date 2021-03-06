resource "aws_cloudwatch_log_group" "agent" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = local.log_retention

  tags = local.tags
}

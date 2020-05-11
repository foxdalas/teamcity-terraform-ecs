resource "aws_efs_file_system" "main" {
  creation_token   = local.name
  performance_mode = local.performance_mode

  tags = local.tags
}

resource "aws_efs_mount_target" "main" {
  count           = length(local.subnets_ids)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = element(local.subnets_ids, count.index)
  security_groups = ["${aws_security_group.main.id}"]
}

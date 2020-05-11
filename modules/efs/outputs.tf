# --------------
# Module Outputs
# --------------
output "security_group_id" {
  value = "${aws_security_group.main.id}"
}

output "filesystem_id" {
  value = "${aws_efs_file_system.main.id}"
}

output "mount_target_id" {
  value = "${aws_efs_mount_target.main.*.id}"
}

output "mount_target_dns_name" {
  value = "${aws_efs_mount_target.main.*.dns_name}"
}

output "mount_target_network_interface_id" {
  value = "${aws_efs_mount_target.main.*.network_interface_id}"
}